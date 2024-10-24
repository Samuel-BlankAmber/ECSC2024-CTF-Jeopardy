<script>
    import { onMount } from "svelte";

    export let page_name;
    let token = null;
    let user = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        try {
            const response = await fetch(`/api/v1/user/`, {
                headers: {
                    Authorization: `${token}`,
                },
            });

            if (response.ok) {
                user = await response.json();
            } else {
                localStorage.clear();
                document.location = "/login";
            }
        } catch (error) {
            localStorage.clear();
            document.location = "/login";
        }
    });
</script>

<div class="flex min-h-screen w-3/4">
    <div class="w-full p-8 bg-gray-100">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold">{page_name}</h1>
            {#if token && user}
                <div class="flex flex-row">
                    <h1 class="m-auto mr-5 text-xl font-bold">
                        Funds: {user.funds}$
                    </h1>
                    <button
                        type="submit"
                        class="bg-primary rounded-lg hover:bg-secondary p-5"
                        on:click|preventDefault={() => {
                            document.location = "/concert";
                        }}>Concerts</button
                    >
                    <button
                        type="submit"
                        class="bg-primary rounded-lg hover:bg-secondary p-5"
                        on:click|preventDefault={() => {
                            document.location = "/book";
                        }}>Bookings</button
                    >
                </div>
            {:else}
                <a href="/login">
                    <button
                        type="submit"
                        class="bg-primary rounded-lg hover:bg-secondary p-5"
                        >Login</button
                    >
                </a>
            {/if}
        </div>
        <slot />
    </div>
</div>
