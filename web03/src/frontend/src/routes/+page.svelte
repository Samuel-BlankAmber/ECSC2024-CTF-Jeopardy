<script lang="ts">
    import { onMount } from 'svelte';
    import {
        DownloadSolid,
        TrashBinSolid,
        ArchiveSolid,
        EyeSolid,
    } from 'flowbite-svelte-icons';
    import {
        Badge,
        Modal,
        Alert,
        Button,
        Heading,
        Spinner,
        Listgroup,
        ListgroupItem,

        Label,
        Input,
    } from 'flowbite-svelte';


    let files: string[] = [];
    let filesLoading: boolean = true;
    async function updateFiles() {
        filesLoading = true;
        const filesResponse = await fetch(
            '/api/v1/Files',
            {
                credentials: 'include'
            }
        );
        files = (await filesResponse.json())['$values'];
        filesLoading = false;
    }
    onMount(updateFiles);

    let addModal = false;
    let addKey: string | undefined;
    let addValue: string | undefined;
    let addFilename: string | undefined;
    let addErrMsg: string | undefined;
    let addLoading: boolean = false;
    async function submitAdd() {
        addLoading = true;

        if ([addKey, addValue, addFilename].some((e) => e == undefined)) {
            addErrMsg = 'Missing required field';
            addLoading = false;
            return;
        }

        let response = await fetch(
            '/api/v1/Files',
            {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    'key': addKey,
                    'value': addValue,
                    'filename': addFilename,
                    'metadata': `Created at ${Date.now()}`,
                }),
                credentials: 'include',
            }
        );
        
        if (response.status != 200) {
            console.log(response.statusText)
            addErrMsg = 'Error while creating file';
        } else {
            addModal = false;
        }

        addLoading = false;
        await updateFiles();
    }

    let visualizeModal: boolean = false;

    let visualizeKey: string = "";
    let visualizeValue: string = "";
    let visualizeMetadata: string = "";
    async function visualizeKV(filename: string) {
        const response = await fetch(
            `/api/v1/Files/${filename}/content`,
            {
                credentials: 'include',
            }
        );
        const content = await response.text();
        const contentList = content.split('|');
        visualizeKey = contentList[0];
        visualizeValue = contentList[1];
        visualizeMetadata = contentList[2];

        visualizeModal = true;
    }

    let notifyModal = false;
    let notifyMsg = "";

    async function backupFile(filename: string) {
        let response = await fetch(
            `/api/v1/Files/${filename}`,
            {
                method: 'POST',
                credentials: 'include',
            }
        )

        if (response.status == 200) {
            notifyMsg = "Backup successful";
        }
        else {
            notifyMsg = "Backup failed";
        }
        notifyModal = true;
    }

    async function deleteFile(filename: string) {
        let response = await fetch(
            `/api/v1/Files/${filename}`,
            {
                method: 'DELETE',
                credentials: 'include',
            }
        )

        if (response.status == 200) {
            notifyMsg = "Entry deleted";
        }
        else {
            notifyMsg = "Error while deleting entry";
        }
        await updateFiles()
        notifyModal = true;
    }
</script>

<div class="flex flex-col items-center justify-center m-4">
    <Heading tag="h1" class="mb-4 w-fit">
        Karma<Badge class="text-xl font-semibold ms-2">VAULT</Badge>
    </Heading>

    <Button on:click={() => { addErrMsg = undefined; addModal = true; }}>Add</Button>
    {#if files.length > 0}
        <Listgroup class="m-6">
            {#each files as file}
                <ListgroupItem>
                    <div class="flex flex-row items-center justify-between">
                        <div>{file}</div>
                        <div class="flex flex-row gap-1 ml-5">
                        <Button size="xs" on:click={() => document.location=`/api/v1/Files/${file}`}>
                            <DownloadSolid />
                        </Button>
                        <Button size="xs" on:click={() => visualizeKV(file)}>
                            <EyeSolid />
                        </Button>
                        <Button size="xs" on:click={() => backupFile(file)}>
                            <ArchiveSolid />
                        </Button>
                        <Button size="xs" on:click={() => deleteFile(file)}>
                            <TrashBinSolid />
                        </Button>
                    </div>
                </ListgroupItem>
            {/each}
        </Listgroup>
    {/if}
</div>

<Modal title="Add" bind:open={addModal}>
    <div class="mb-6">
        <Label for="add-filename" class="block mb-2">Filename</Label>
        <Input id="add-filename" placeholder="Filename" bind:value={addFilename} />
        <Label for="add-key" class="block mb-2">Key</Label>
        <Input id="add-key" placeholder="Key" bind:value={addKey} />
        <Label for="add-value" class="block mb-2">Value</Label>
        <Input id="add-value" placeholder="Value" bind:value={addValue} />
    </div>
    <svelte:fragment slot="footer">
        <div class="flex flex-row items-center">
            <Button on:click={submitAdd}>Crea</Button>
            {#if addLoading}
                <Spinner class="ml-3" />
            {/if}
        </div>
        {#if addErrMsg != undefined}
            <Alert color="red">{addErrMsg}</Alert>
        {/if}
    </svelte:fragment>
</Modal>

<Modal title="Visualize" bind:open={visualizeModal}>
    <div class="mb-6">
        <h4>Key: {visualizeKey}</h4>
        <h4>Value: {visualizeValue}</h4>
        <h4>{visualizeMetadata}</h4>
    </div>
</Modal>

<Modal title="Notification" bind:open={notifyModal}>
    <div class="mb-6">
        <h4>{notifyMsg}</h4>
    </div>
</Modal>