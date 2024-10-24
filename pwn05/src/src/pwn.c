#include <linux/miscdevice.h>
#include <linux/fs.h>
#include <linux/mm.h>
#include <linux/init.h>
#include <linux/gfp.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/io.h>

static void pwn_vma_open(struct vm_area_struct *vma) {}

static void pwn_vma_close(struct vm_area_struct *vma)
{
    if (vma->vm_private_data)
    {
        free_page((unsigned long)vma->vm_private_data);
        vma->vm_private_data = NULL;
    }
}

static vm_fault_t pwn_vma_fault(struct vm_fault *vmf)
{
    struct vm_area_struct *vma = vmf->vma;
    void *p;
    int ret;

    p = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
    if (!p)
        return VM_FAULT_OOM;

    ret = vmf_insert_pfn(vma, vma->vm_start, virt_to_phys(p) >> PAGE_SHIFT);
    if (ret != VM_FAULT_NOPAGE)
    {
        free_page((unsigned long)p);
        return ret;
    }

    vma->vm_private_data = p;
    return ret;
}

static int pwn_vma_may_split(struct vm_area_struct *area, unsigned long addr)
{
    return -EINVAL;
}

static int pwn_vma_mremap(struct vm_area_struct *area)
{
    return -EINVAL;
}

static struct vm_operations_struct pwn_vm_ops = {
    .open = pwn_vma_open,
    .close = pwn_vma_close,
    .fault = pwn_vma_fault,
    .may_split = pwn_vma_may_split,
    .mremap = pwn_vma_mremap
};

static int pwn_mmap(struct file *filp, struct vm_area_struct *vma)
{
    if (vma_pages(vma) != 1 || vma->vm_pgoff != 0)
        return -EINVAL;

    vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTCOPY | VM_DONTDUMP);
    vma->vm_ops = &pwn_vm_ops;
    vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
    vma->vm_private_data = NULL;
    return 0;
}

static struct file_operations pwn_fops = {
    .owner = THIS_MODULE,
    .mmap = pwn_mmap,
};

static struct miscdevice pwn_dev = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = "pwn",
    .fops = &pwn_fops
};

static int __init pwn_init(void)
{
    if (misc_register(&pwn_dev))
    {
        pr_err("misc_register failed\n");
        return -1;
    }

    return 0;
}

static void __exit pwn_exit(void)
{
    misc_deregister(&pwn_dev);
}

module_init(pwn_init);
module_exit(pwn_exit);

MODULE_AUTHOR("Bonfee");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Pwnable kmod");
