namespace bai2.Class
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("NHANVIEN")]
    public partial class NHANVIEN
    {
        [StringLength(5)]
        public string MANV { get; set; }

        [Required]
        [StringLength(50)]
        public string HOTENNV { get; set; }

        public DateTime NGAYSINH { get; set; }

        public bool GIOITINH { get; set; }

        [StringLength(50)]
        public string DIACHI { get; set; }

        [StringLength(50)]
        public string LOAINV { get; set; }

        public DateTime NGAYVAOLAM { get; set; }

        public int LUONGCB { get; set; }

        public string GHICHU { get; set; }

        [StringLength(5)]
        public string MACN { get; set; }
    }
}
