using System.Data.Entity;

namespace ESFA.DC.Data.LargeEmployer.Model.Interface
{
    public interface ILargeEmployers
    {
        DbSet<LargeEmployers> LargeEmployers { get; set; }

        DbSet<SourceFile> SourceFiles { get; set; }

        DbSet<VersionInfo> VersionInfoes { get; set; }
    }
}
