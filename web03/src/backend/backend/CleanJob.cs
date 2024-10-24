using Quartz;

namespace Jobs
{
    public class CleanJob : IJob
    {
        public Task Execute(IJobExecutionContext ctx)
        {
            var directories = new List<string> { "/tmp/backup", "/tmp/vault" };
            foreach (var directory in directories) {
                try
                {
                    Directory.Delete(directory, true);
                    Console.WriteLine($"[INFO] CleanJob.Execute: Removed {directory}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[WARN] CleanJob.Execute: Failed to remove {directory} ({ex.Message})");
                }
            }
            return Task.CompletedTask;
        }
    }
}
