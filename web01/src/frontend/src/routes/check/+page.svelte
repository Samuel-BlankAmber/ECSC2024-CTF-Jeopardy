<script>
    import { onMount } from "svelte";
    import Spinner from "../../components/Spinner/Spinner.svelte";
    import MainPage from "../../components/MainPage/MainPage.svelte";

    let concerts = [];
    let token = null;
    let error = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        if (!token) {
            document.location = "/login";
        }

        try {
            const response = await fetch("/api/v1/user/concert/", {
                headers: {
                    Authorization: token,
                },
            });
            if (response.ok) {
                concerts = await response.json();
            } else {
                error = "Failed to fetch concerts";
            }
        } catch (error) {
            error = "Failed to fetch concerts";
        }
    });
</script>

<MainPage page_name="Your concerts">
    {#if concerts}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
            {#each concerts as concert}
                <div class="bg-white shadow-lg rounded-lg p-6">
                    <a href="/check/{concert.concert_id}/">
                        <h2 class="text-2xl font-semibold mb-2">
                            {concert.name}
                        </h2>
                    </a>
                    <div>
                        <span class="text-sm text-gray-500"
                            >Date: {new Date(
                                concert.date,
                            ).toLocaleDateString()}</span
                        >
                    </div>
                    <div>
                        <span class="text-sm text-gray-500"
                            >Secret code: {concert.secret_code}</span
                        >
                    </div>
                </div>
            {/each}
        </div>
    {:else}
        <Spinner />
    {/if}

    {#if error}
        <p class="text-red-500 mt-4">{error}</p>
    {/if}
</MainPage>
