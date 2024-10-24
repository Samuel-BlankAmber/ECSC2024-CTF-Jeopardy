<script>
    import { onMount } from "svelte";
    import Spinner from "../../components/Spinner/Spinner.svelte";
    import MainPage from "../../components/MainPage/MainPage.svelte";

    let concerts = [];
    let token = null;
    let error = null;

    onMount(async () => {
        token = localStorage.getItem("token");
        try {
            const response = await fetch("/api/v1/concert/");
            if (response.ok) {
                concerts = await response.json();
            } else {
                error = "Failed to fetch concerts";
            }
        } catch (error) {
            error = "Failed to fetch concerts";
        }
    });

    let concert_name = null;
    let concert_date = null;
    let secret_code = null;
    let price = null;

    const add_concert = async () => {
        let response = await fetch("/api/v1/user/concert/", {
            method: "POST",
            headers: {
                Authorization: token,
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: `name=${concert_name}&date=${concert_date}&secret_code=${secret_code}&price=${price}`,
        });

        let data = await response.json();
        alert(response.ok ? data.message : data.error);
        document.location.reload();
    };
</script>

<MainPage page_name="Concerts">
    {#if concerts.length > 0}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
            {#each concerts as concert}
                <div class="bg-white shadow-lg rounded-lg p-6">
                    <a href="/concert/{concert.id}/">
                        <h2 class="text-2xl font-semibold mb-2">
                            {concert.name}
                        </h2>
                    </a>
                    <span class="text-sm text-gray-500"
                        >Date: {new Date(
                            concert.date,
                        ).toLocaleDateString()}</span
                    >
                </div>
            {/each}
        </div>
    {:else}
        <Spinner />
    {/if}

    {#if token}
        <h1 class="text-3xl font-bold">Add your concert</h1>

        <form action="/register" method="POST" class="flex flex-col">
            <div class="mb-4">
                <label class="block text-gray-700" for="concert_name"
                    >Singer</label
                >
                <input
                    type="text"
                    id="concert_name"
                    name="concert_name"
                    bind:value={concert_name}
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-bg-secondary"
                    required
                />
            </div>
            <div class="mb-4">
                <label class="block text-gray-700" for="password">Date</label>
                <input
                    type="text"
                    id="concert_date"
                    name="concert_date"
                    bind:value={concert_date}
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-bg-secondary"
                    required
                />
            </div>
            <div class="mb-4">
                <label class="block text-gray-700" for="password"
                    >Secret code</label
                >
                <input
                    type="text"
                    id="secret_code"
                    name="secret_code"
                    bind:value={secret_code}
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-bg-secondary"
                    required
                />
            </div>
            <div class="mb-4">
                <label class="block text-gray-700" for="password">Price</label>
                <input
                    type="number"
                    id="price"
                    name="price"
                    bind:value={price}
                    class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-bg-secondary"
                    required
                />
            </div>
            <button
                type="submit"
                class="w-1/4 m-auto bg-primary px-4 py-2 rounded-lg hover:bg-secondary"
                on:click|preventDefault={add_concert}>Add</button
            >
        </form>
    {/if}

    {#if error}
        <p class="text-red-500 mt-4">{error}</p>
    {/if}
</MainPage>
