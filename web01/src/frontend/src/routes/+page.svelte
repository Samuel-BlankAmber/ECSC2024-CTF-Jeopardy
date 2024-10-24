<script>
    import { onMount } from "svelte";

    let token = null;

    onMount(async () => {
        token = localStorage.getItem("token");

        if (!token) {
            document.location = "/login";
        }
    });
</script>

<div class="flex min-h-screen w-3/4 justify-center align-center flex-row">
    <div class="w-full m-auto flex flex-row justify-center">
        <a href="/concert" class="w-1/4 block m-10">
            <button
                type="submit"
                class="bg-primary rounded-lg hover:bg-secondary p-5 inline-block w-full"
                >Go to concerts</button
            >
        </a>
        <a href="/check" class="w-1/4 block m-10">
            <button
                type="submit"
                class="bg-primary rounded-lg hover:bg-secondary p-5 inline-block w-full"
                >Check tickets</button
            >
        </a>
    </div>
</div>
