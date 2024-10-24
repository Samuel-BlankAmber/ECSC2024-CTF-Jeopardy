<script>
    import { onMount } from "svelte";
    import Spinner from "../../../components/Spinner/Spinner.svelte";
    import MainPage from "../../../components/MainPage/MainPage.svelte";
    import QRCode from "qrcode";

    let booking = [];
    export let data;
    let token = null;
    let error = null;
    let qrcode = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        if (!token) {
            document.location.href = "/login";
        }

        try {
            const response = await fetch(
                `/api/v1/user/bookings/${data.book_id}/`,
                {
                    headers: {
                        Authorization: `${token}`,
                    },
                },
            );
            if (response.ok) {
                booking = await response.json();
            } else {
                error = "Failed to fetch booking";
            }
        } catch (error) {
            error = "Failed to fetch booking";
        }
    });

    let comment = null;
    const build_qr_code = async () => {
        let text = `serial=${booking.serial}`;

        if (comment) {
            text += `&comment=${comment}`;
        }

        qrcode = await QRCode.toDataURL(text);
    };
</script>

<MainPage page_name={booking.name}>
    {#if booking}
        <div class="flex flex-col">
            <div class="text-xl">
                Date: {booking.date}
            </div>

            {#if !qrcode}
                <form action="/register" method="POST" class="flex flex-col">
                    <div class="mb-4">
                        <label class="block text-gray-700" for="comment"
                            >Comment</label
                        >
                        <input
                            type="text"
                            id="comment"
                            name="comment"
                            bind:value={comment}
                            class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-bg-secondary"
                            required
                        />
                    </div>

                    <button
                        type="submit"
                        class="w-1/4 m-auto bg-primary px-4 py-2 rounded-lg hover:bg-secondary"
                        on:click|preventDefault={build_qr_code}
                    >
                        CHECK
                    </button>
                </form>
            {:else}
                <img class="m-auto" src={qrcode} width="200px" alt="qrcode" />
            {/if}
        </div>
    {:else}
        <Spinner />
    {/if}
</MainPage>
