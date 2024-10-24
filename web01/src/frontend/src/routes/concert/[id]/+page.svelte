<script>
    import { onMount } from "svelte";
    import Spinner from "../../../components/Spinner/Spinner.svelte";
    import MainPage from "../../../components/MainPage/MainPage.svelte";

    let concert = [];
    export let data;
    let token = null;
    let error = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        try {
            const response = await fetch(`/api/v1/concert/${data.concert_id}/`);
            if (response.ok) {
                concert = await response.json();
            } else {
                error = "Failed to fetch concert";
            }
        } catch (error) {
            error = "Failed to fetch concert";
        }
    });

    const purchase_ticket = async () => {
        try {
            const response = await fetch(`/api/v1/concert/${data.concert_id}/book/`, {
                method: "POST",
                headers: {
                    Authorization: `${token}`,
                },
            });

            if (response.ok) {
                window.location.href = `/`;
            } else {
                let response_data = await response.json();
                alert(response_data.error);
            }
        } catch (error) {
            error = "Failed to purchase ticket";
        }
    };
</script>

<MainPage page_name={concert.name}>
    {#if concert}
        <div class="flex flex-col">
            <div class="text-xl">
                Date: {concert.date}
            </div>

            {#if token}
                <button
                    type="submit"
                    class="w-1/4 m-auto bg-primary px-4 py-2 rounded-lg hover:bg-secondary"
                    on:click|preventDefault={purchase_ticket}
                >
                    Purchase ticket - {concert.price}$
                </button>
            {/if}
        </div>
    {:else}
        <Spinner />
    {/if}
</MainPage>
