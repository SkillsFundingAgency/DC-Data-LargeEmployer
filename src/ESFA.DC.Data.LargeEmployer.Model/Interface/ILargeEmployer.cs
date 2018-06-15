using System.Data.Entity;

namespace ESFA.DC.Data.LargeEmployer.Model.Interface
{
    public interface ILargeEmployer
    {
        DbSet<LEMP_Employers> LEMP_Employers { get; set; }

        DbSet<LEMP_SourceFile> LEMP_SourceFile { get; set; }

        DbSet<LEMP_VersionInfo> LEMP_VersionInfo { get; set; }
    }
}
