<script>
    import { onMount } from "svelte";
    import Spinner from "../../components/Spinner/Spinner.svelte";
    import MainPage from "../../components/MainPage/MainPage.svelte";

    let bookings = [];
    let token = null;
    let error = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        if(!token){
            document.location = "/login";
        }

        try {
            const response = await fetch("/api/v1/user/bookings/",{
                headers:{
                    "Authorization":token
                }
            });
            if (response.ok) {
                bookings = await response.json();
            } else {
                error = "Failed to fetch bookings";
            }
        } catch (error) {
            error = "Failed to fetch bookings";
        }
    });

</script>

<MainPage page_name="Booking">
    {#if bookings.length > 0}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
            {#each bookings as b}
                <div class="bg-white shadow-lg rounded-lg p-6">
                    <a href="/book/{b.id}/">
                        <h2 class="text-2xl font-semibold mb-2">
                            {b.name}
                        </h2>
                    </a>
                    <span class="text-sm text-gray-500"
                        >Date: {new Date(
                            b.date,
                        ).toLocaleDateString()}</span
                    >
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
