<script>
    import { onMount } from "svelte";
    import Spinner from "../../../components/Spinner/Spinner.svelte";
    import MainPage from "../../../components/MainPage/MainPage.svelte";
    import jsQR from "jsqr";
    import { Buffer } from "buffer";
    import { Jimp } from "jimp";

    let concert = [];
    export let data;
    let token = null;
    let error = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        if (!token) {
            alert("not token");
            document.location = "/login";
        }

        try {
            const response = await fetch(
                `/api/v1/user/concert/${data.concert_id}/`,
                {
                    headers: {
                        Authorization: token,
                    },
                },
            );
            if (response.ok) {
                concert = await response.json();
            } else {
                alert("response not ok");
                document.location = "/login";
            }
        } catch (error) {
            error = "Failed to fetch concert";
        }
    });

    let qrcode = null;
    let preview = null;

    const handle_file_update = () => {
        let file_reader = new FileReader();
        file_reader.onload = (e) => {
            preview = e.target.result;
        };
        file_reader.readAsDataURL(qrcode[0]);
    };

    const check_ticket = async () => {
        const base64_image = preview.replace(/^data:image\/[a-z]+;base64,/, "");
        const qrBuffer = Buffer.from(base64_image, "base64");
        const image = await Jimp.read(qrBuffer);

        const imageData = {
            data: new Uint8ClampedArray(image.bitmap.data),
            width: image.bitmap.width,
            height: image.bitmap.height,
        };

        const result = jsQR(imageData.data, imageData.width, imageData.height);

        if (!result) {
            alert("Failed to check ticket, invalid QR code");
            return;
        }

        let params = new URLSearchParams(result.data);
        let serial = params.get("serial");
        let comment = params.get("comment");

        try {
            const response = await fetch(`/api/v1/check/${serial}/`, {
                method: "POST",
                headers: {
                    Authorization: token,
                    "Content-Type": "application/x-www-form-urlencoded",
                },
                body: comment ? `comment=${comment}` : "",
            });

            if (response.ok) {
                alert("Ticket correctly checked in");
            } else {
                alert("Ticket is invalid");
            }
        } catch (error) {
            alert("Failed to check ticket");
        }
    };

    let username = null;

    const add_checker = async () => {
        if (!username) {
            alert("Please enter a username");
            return;
        }

        try {
            const response = await fetch(
                `/api/v1/concert/${data.concert_id}/checker/`,
                {
                    method: "POST",
                    headers: {
                        Authorization: token,
                        "Content-Type": "application/x-www-form-urlencoded",
                    },
                    body: `username=${username}`,
                },
            );

            if (response.ok) {
                alert("Checker correctly added");
            } else {
                alert("Checker does not exists");
            }
        } catch (error) {
            console.log(error);
            alert("Failed to add checker");
        }
    };
</script>

<MainPage page_name={concert.name}>
    {#if concert}
        <div class="flex flex-col">
            <form action="/check" method="POST" class="flex flex-col my-10">
                <h1 class="text-3xl font-bold">Check a concert ticket</h1>

                <label class="block text-gray-700" for="qrcode"
                    >Upload the photo of your QR code</label
                >

                {#if !preview}
                    <input
                        type="file"
                        name="qrcode"
                        id="qrcode"
                        bind:files={qrcode}
                        on:change|preventDefault={handle_file_update}
                    />
                {:else}
                    <img
                        class="m-auto my-5"
                        src={preview}
                        width="200px"
                        alt="qrcode"
                    />
                    <button
                        type="submit"
                        class="w-1/4 m-auto bg-primary px-4 py-2 rounded-lg hover:bg-secondary"
                        on:click|preventDefault={check_ticket}
                    >
                        Check ticket
                    </button>
                {/if}
            </form>

            <h1 class="text-3xl font-bold">Add a checker to your concert</h1>

            <form action="/add_checker" method="POST" class="flex flex-col">
                <div class="mb-4">
                    <label class="block text-gray-700" for="concert_name"
                        >Username</label
                    >
                    <input
                        type="text"
                        id="username"
                        name="username"
                        bind:value={username}
                        class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-bg-secondary"
                        required
                    />
                </div>
                <button
                    type="submit"
                    class="w-1/4 m-auto bg-primary px-4 py-2 rounded-lg hover:bg-secondary"
                    on:click|preventDefault={add_checker}>Add</button
                >
            </form>
        </div>
    {:else}
        <Spinner />
    {/if}
</MainPage>
