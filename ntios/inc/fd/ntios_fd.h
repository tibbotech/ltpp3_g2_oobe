/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef STOR_NTIOS_FD_H_
#define STOR_NTIOS_FD_H_

#include <string>
#include "base/ntios_property.h"
#include "base/ntios_types.h"

#define EXT_FLASH_4MB 1

typedef enum {
    PL_FD_STATUS_OK,                            //Completed successfully.
    PL_FD_STATUS_FAIL,                          //Physical flash memory failure (fatal: disk dismounted, must be reformatted).
    PL_FD_STATUS_CHECKSUM_ERR,                  //Checksum error has been detected in one of the disk sectors (fatal: disk dismounted, must be reformatted).
    PL_FD_STATUS_FORMAT_ERR,                    //Disk formatting error has been detected (fatal: disk dismounted, must be reformatted).
    PL_FD_STATUS_INV_PARAM,                     //Invalid argument have been provided for the invoked method.
    PL_FD_STATUS_DUPLICATE_NAME,                //File with this name already exists.
    PL_FD_STATUS_FILE_TABLE_FULL,               //Maximum number of files that can be stored on the disk has been reached, new file cannot be created.
    PL_FD_STATUS_DATA_FULL,                     //The disk is full, new data cannot be added.
    PL_FD_STATUS_NOT_READY,                     //The disk is not mounted.
    PL_FD_STATUS_NOT_FOUND,                     //File not found.
    PL_FD_STATUS_NOT_OPENED,                    //No file is currently opened "on" the current fd.filenum.
    PL_FD_STATUS_ALREADY_OPENED,                //This file is already opened "on" some other file number.
    PL_FD_STATUS_TRANSACTION_ALREADY_STARTED,   //Disk transaction has already been started (and cannot be restarted).
    PL_FD_STATUS_TRANSACTION_NOT_YET_STARTED,   //Disk transaction hasn't been started yet.
    PL_FD_STATUS_TRANSACTION_CAPACITY_EXCEEDED, //Too many disk sectors have been modified in the cause of the current transaction (fatal: disk dismounted).
    PL_FD_STATUS_TRANSACTIONS_NOT_SUPPORTED,    //The disk wasn't formatted to support transactions (use fd.formatj with maxjournalsectors>1 to enable transactions).
    PL_FD_STATUS_FLASH_NOT_DETECTED             //Flash IC wasn't detected during boot, fd. object cannot operate normally.
} pl_fd_status_codes; 

//these codes allow us to understand what happened
typedef enum {  
	FD_NO_ADDITIONAL_ERROR_DATA,
	FD_MOUNT_BOOT_READ_ERROR,
	FD_MOUNT_BOOT_CS_ERROR,
	FD_MOUNT_BOOT_MARKER_INVALID,
	FD_MOUNT_BOOT_DATA_INVALID,
	FD_MOUNT_ENDBOOT_READ_ERROR,
	FD_MOUNT_ENDBOOT_CS_ERROR,
	FD_MOUNT_ENDBOOT_DATA_INVALID,
	FD_MOUNT_FRT_READ_ERROR,
	FD_MOUNT_FRT_CS_ERROR,
	FD_MOUNT_FRT_LOGICAL_NUMBER_OOR,
	FD_MOUNT_FRT_LOGICAL_NUMBER_DUPLICATION,
	FD_MOUNT_FRT_WRITE_ERROR_1,
	FD_MOUNT_FRT_WRITE_ERROR_2,
	FD_MOUNT_FRT_INVALID_ACTIVE_SECTOR_COUNT,
	FD_MOUNT_FRT_EMPTY_MAPPING_DETECTED,
	FD_MOUNT_FAT_READ_ERROR,
	FD_MOUNT_FAT_CS_ERROR,
	FD_MOUNT_FAT_LOGICAL_NUMBER_OOR,
	FD_FAT_LOGICAL_NUMBER_DUPLICATION,
	FD_MOUNT_FAT_WRITE_ERROR_1,
	FD_MOUNT_FAT_WRITE_ERROR_2,
	FD_MOUNT_FAT_INVALID_ACTIVE_SECTOR_COUNT,
	FD_MOUNT_FAT_EMPTY_MAPPING_DETECTED,
	FD_FORMAT_BOOT_WRITE_ERROR,
	FD_FORMAT_ENDBOOT_WRITE_ERROR,
	FD_FORMAT_FRT_WRITE_ERROR,
	FD_FORMAT_FAT_WRITE_ERROR,
	FD_RENAME_COMMON_PORTION_ERROR,
	FD_RENAME_FRT_READ_ERROR,
	FD_RENAME_FRT_CS_ERROR,
	FD_RENAME_FRT_WRITE_ERROR,
	FD_OPEN_COMMON_PORTION_ERROR,
	FD_OPEN_FRT_READ_ERROR,
	FD_OPEN_FRT_CS_ERROR,
	FD_OPEN_FRT_WRITE_ERROR,
	FD_FLUSH_DATASECTOR_WRITE_ERROR,
	FD_SETATTRIBUTES_COMMON_PORTION_ERROR,
	FD_SETATTRIBUTES_FRT_READ_ERROR,
	FD_SETATTRIBUTES_FRT_CS_ERROR,
	FD_SETATTRIBUTES_FRT_WRITE_ERROR,
	FD_DELETE_COMMON_PORTION_ERROR,
	FD_DELETE_FRT_READ_ERROR,
	FD_DELETE_FRT_CS_ERROR,
	FD_DELETE_FRT_WRITE_ERROR,
	FD_DELETE_ENTRY_SECTOR_INVALID,
	FD_DELETE_FAT_WRITE_ERROR_1,
	FD_DELETE_FAT_READ_ERROR,
	FD_DELETE_FAT_CS_ERROR,
	FD_DELETE_INVALID_FAT_CHAIN_1,
	FD_DELETE_INVALID_FAT_CHAIN_2,
	FD_DELETE_FAT_WRITE_ERROR_2,
	FD_CREATE_COMMON_PORTION_ERROR,
	FD_CREATE_FAT_READ_ERROR,
	FD_CREATE_FAT_CS_ERROR,
	FD_CREATE_FAT_WRITE_ERROR,
	FD_CREATE_DATASECTOR_WRITE_ERROR,
	FD_CREATE_FRT_READ_ERROR,
	FD_CREATE_FRT_CS_ERROR,
	FD_CREATE_FRT_WRITE_ERROR,
	FD_GETNUMFILES_FRT_READ_ERROR,
	FD_GETNUMFILES_FRT_CS_ERROR,
	FD_GETNEXTDIRMEMBER_FRT_READ_ERROR,
	FD_GETNEXTDIRMEMBER_FRT_CS_ERROR,
	FD_FREESPACE_FAT_READ_ERROR,
	FD_FREESPACE_FAT_CS_ERROR,
	FD_FREESPACE_FAT_INVALID_DATA,
	FD_FINDFREESECTOR_FAT_INVALID_DATA,
	FD_FINDFREESECTOR_FAT_READ_ERROR,
	FD_FINDFREESECTOR_FAT_CS_ERROR,
	FD_GETDATA_DATASECT_READ_ERROR_1,
	FD_GETDATA_DATASECT_CS_ERROR_1,
	FD_GETDATA_DATASECT_READ_ERROR_2,
	FD_GETDATA_DATASECT_CS_ERROR_2,
	FD_GETDATA_DATASECT_READ_ERROR_3,
	FD_GETDATA_DATASECT_CS_ERROR_3,
	FD_SETDATA_DATASECT_READ_ERROR_1,
	FD_SETDATA_DATASECT_CS_ERROR_1,
	FD_SETDATA_DATASECT_READ_ERROR_2,
	FD_SETDATA_DATASECT_CS_ERROR_2,
	FD_SETDATA_DATASECT_READ_ERROR_3,
	FD_SETDATA_DATASECT_CS_ERROR_3,
	FD_SETDATA_DATASECT_READ_ERROR_4,
	FD_SETDATA_DATASECT_CS_ERROR_4,
	FD_GNSOFC_READ_ERROR_1,
	FD_GNSOFC_CS_ERROR_1,
	FD_GNSOFC_CHAIN_ERROR_1,
	FD_GNSOFC_CHAIN_ERROR_2,
	FD_GNSOFC_READ_ERROR_2,
	FD_GNSOFC_CS_ERROR_2,
	FD_GNSOFC_READ_ERROR_3,
	FD_GNSOFC_CS_ERROR_3,
	FD_GNSOFC_READ_ERROR_4,
	FD_GNSOFC_CS_ERROR_4,
	FD_GNSOFC_WRITE_ERROR,
	FD_SAVE_FAT_SECTOR_WRITE_ERROR_1,
	FD_SAVE_FAT_SECTOR_WRITE_ERROR_2,
	FD_SAVE_FRT_SECTOR_WRITE_ERROR_1,
	FD_SAVE_FRT_SECTOR_WRITE_ERROR_2,
	FD_FIND_DATASECTOR_READ_ERROR_1,
	FD_FIND_DATASECTOR_CS_ERROR_1,
	FD_FIND_DATASECTOR_READ_ERROR_2,
	FD_FIND_DATASECTOR_CS_ERROR_2,
	FD_FIND_DATASECTOR_READ_ERROR_3,
	FD_FIND_DATASECTOR_CS_ERROR_3,
	FD_FIND_GNSOFC_READ_ERROR_1,
	FD_FIND_GNSOFC_CS_ERROR_1,
	FD_FIND_GNSOFC_CHAIN_ERROR,
	FD_MOUNT_JOURNAL_DATA_INVALID,
	FD_MOUNT_JOURNAL_COMM_FAILED,
	FD_MOUNT_JOURNAL_COMM_FAILED2
} fd_error_data_codes; 

typedef enum {
    PL_FD_CSUM_MODE_VERIFY,   //PLATFORM CONSTANT. Verify the checksum.
    PL_FD_CSUM_MODE_CALCULATE //PLATFORM CONSTANT. Calculate the checksum.
} pl_fd_csum_mode; 

/* these status CODE are separately declared in many TDLs -- do not change */
typedef enum {  
	FD_OK, /* all finished successfully */
	FD_FAIL, /* hardware failure or unspecified error */
	FD_CS, /* checksum error */
	FD_FORMAT, /* error in the housekeeping area of the file */
	FD_INV_PARAM, /* invalid input data (i.e. parameters that lead to invalid results) */ 
	FD_DUPL_NAME, /* duplicate file name */
	FD_FRT_FULL, /* no place to store another file record */
	FD_DATA_FULL, /* no free data sectors */
	FD_NOT_READY, /* because the disk is not ready before the operation already */
	FD_NOT_FOUND, /* file not found */
	FD_NOT_OPENED, /* file is not opened */
	FD_ALREADY_OPENED, /* this file is already opened */
	FD_TRANSACTION_ALREADY_STARTED,
	FD_TRANSACTION_NOT_YET_STARTED,
	FD_TRANSACTION_CAPACITY_EXCEEDED,
	FD_TRANSACTIONS_NOT_SUPPORTED,
	FD_FLASH_NOT_DETECTED
} fd_status_codes;

typedef enum {  
    FORWARD,           //GENERIC PLATFORM CONSTANT.
    BACK               //GENERIC PLATFORM CONSTANT.
} forward_back;


typedef enum {  
    PL_FD_FIND_EQUAL,         //PLATFORM CONSTANT. Find data that is equal to the substr.
    PL_FD_FIND_NOT_EQUAL,     //PLATFORM CONSTANT. Find data that is not equal to the substr.
    PL_FD_FIND_GREATER,       //PLATFORM CONSTANT. Find data with value greater than the value of the substr.
    PL_FD_FIND_GREATER_EQUAL, //PLATFORM CONSTANT. Find data with value greater than or equal to the value of the substr.
    PL_FD_FIND_LESSER,        //PLATFORM CONSTANT. Find data with value less than the value of the substr.
    PL_FD_FIND_LESSER_EQUAL   //PLATFORM CONSTANT. Find data with value less than or equal to the value of the substr.
} pl_fd_find_modes;

typedef enum {  	
	OP_EQ,		//equal
	OP_NEQ,		//not equal
	OP_GR,		//greater than
	OP_GREQ,	//greater than or equal
	OP_LS,		//less than
	OP_LSEQ		//less than or equal
} find_mode;


#define SET_SPI_CS
#define CLR_SPI_CS
#define DUMMY_BYTE 0xA5			       

#define TIOS_API_FD_EMPTY_BYTE  0xFF
#if EXT_FLASH_4MB == 1
#define TIOS_API_FD_SECTOR_SIZE 528
#else
#define TIOS_API_FD_SECTOR_SIZE 264
#endif
#define TIOS_API_LFD_OPEN_FILES_MAX 256

#define FRT_REC_ACTIVE_TAG 0x5A
#define MAX_NAME_ATTR_LEN 56

#define FD_MAX_OPENED_FILES 8
#define FD_MAX_JOURNAL_ENTRIES 16 //do not changed, it is also declared in ASM (including TDL#64, etc.)
#define FD_JOURNAL_COMMIT_MARKER_B0 224
#define FD_JOURNAL_COMMIT_MARKER_B1 113
#define FD_JOURNAL_COMMIT_MARKER_B2 45
#define FD_JOURNAL_COMMIT_MARKER_B3 51

/* Size of physical flash sector. We use 256 bytes for actual data storage. Remaining 8 bytes are used for internal housekeeping:
offset +256:		logical sector number (for sectors in FRT and FAT areas only, unused for sectors in the data area)
offset +257:		instance number (for sectors in FRT and FAT areas only, unused for sectors in the data area)
offset +262,263:	16-bit checksum (16-bit sum of all bytes in the sector including the checksum should be 0000H )

Additional comments for FRT and FAT sectors:
(1) Logical number OR instance number of inactive sector should be 0xFF (in practice, we try to set them both to 0xFF when the sector is inactive).
(2) During formatting, we mark necessary number of physical sectors with logical numbers from 0 and up. All instance number are set to 0.
(3) Note that FRT area is TWICE as large as the number of active sectors needed, so logical and instance numbers of 1/2 of the sectors will be 0xFF.
(4) FAT area is AT LEAST TWICE as large, so HALF OR MORE of sectors will remain in 0xFF.
(5) When mounting the disk with fd.mount() the system will find active sectors and create logical->physical mapping in the frt_index_tab and fat_index_tab.
(6) If two physical sectors with the same logical number are found, the following rules apply:
	(a) If both sectors have the same instance number then this is an error (FORMAT error, unrecoverable).
	(b) If one sector has higher number then this sector is selected as the "latest" sector, unless...
	(c) ...the instance numbers are 0 and 254, in which case sector with number 0 is the latest. This achieves roll-over.
	(d) During mounting all "earlier" sectors are erased (this is our method of "garbage collection").
	(e) When changing the sector in the FRT or FAT area, the system does the following:
		- Selects unused sector and saves changed data there.
		- Logical number of this sector is the same as the logical number of the sector being changed.
		- Instance number of the sector is instance_number_of_original_sector+1, except 0xFE rolls into 0. (0xFF means "inactive" sector).
		- Original sector is then erased. In this way power failure at any time won't affect the disk, just the latest data may be lost.
*/
#if EXT_FLASH_4MB == 1
	#define SECT_SIZE 528
#else
	#define SECT_SIZE 264
#endif	


/* capacity of each sector not counting special bytes that store checksum, etc. */
#if EXT_FLASH_4MB == 1
	#define SECT_SIZE_DATA_ONLY 512
#else
	#define SECT_SIZE_DATA_ONLY 256
#endif	


/* always 1 sector, keeps important data such as the size of FRT, FAT, and DATA areas of the disk */
#define BOOT_SIZE 1

/* always 1 sector, keeps the same data as BOOT sector. Here is why this sector exists. The flash disk "grows" from the top of flash memory down.
That is, the first BOOT sector is the LAST sector in the IC. We did it this way so that changing application program (growing from bottom up) will
destroy the disk as infrequently as possible. If the application program encroaches on the disk space the END_BOOT sector will be damaged and we
will be able to detect this in fd.mount() */
#define END_BOOT_SIZE 1

/* Minimum space allocated for FRT table. Only half of all sectors can be active, so this means that minimum number of files that can be created
is (MIN_FRT_SPACE/2)*how_many_file_records_fits_in_one_FRT_sector. */
#if EXT_FLASH_4MB == 1
	#define MIN_FRT_SIZE 4
#else
	#define MIN_FRT_SIZE 8
#endif

/* Maximum number of active FRT records that can be requested. This defines the total number of files that can be on the disk as:
(MIN_FRT_SPACE/2)*how_many_file_records_fits_in_one_FRT_sector. Actual FRT area will be twice as large, since only 1/2 of all FRT sectors can be
active at any given time. And why do we even have this MAX_REQ_FRT_SIZE limitation? Because there is frt_index_tab[] array, and we need to define
its size! ********** THIS CONSTANT CANNOT BE JUST CHANGED -- frt_index_tab[] IS DECLARED IN MANY OTHER FILES ************** */
#if EXT_FLASH_4MB == 1
	#define MAX_REQ_FRT_SIZE 8
#else
	#define MAX_REQ_FRT_SIZE 16
#endif		

/* Minimum space allocated for FAT, active sectors can occupy NOT MORE THAN 50% of this space (different from FRT, where it is EXACTLY 50% of space).
Actual required number of active sectors is calculated as (SECT_SIZE_DATA_ONLY/2)*num_sectors_in_the_data_area. "/2" is because each FAT entry has
two bytes (sector address in the DATA area). If the total size of FAT area (according to this calculation) turns out to be <MIN_FAT_SIZE then the 
size of the FAT area is still set to MIN_FAT_SIZE */
#if EXT_FLASH_4MB == 1
	#define MIN_FAT_SIZE 8
#else
	#define MIN_FAT_SIZE 16
#endif

/* Maximum number of active FAT sectors. Actual FAT area is at least MIN_FAT_SIZE in size OR twice the MAXD_REQ_FAT_SIZE, whichever is larger.
This constant is significant because the fat_index_tab[] is declared of MAX_REQ_FAT_SIZE size. ******* DO NOT JUST CHANGE-- there are other files
where this constant and array are also declared ***********. */
#define MAX_REQ_FAT_SIZE 32 

#if EXT_FLASH_4MB == 1
	#define MAX_REQ_FRT_SIZE 8
#else
	#define MAX_REQ_FRT_SIZE 16
#endif

#define MAX_REQ_FAT_SIZE 32

struct fd_file_struct {
	U8 file_opened; /* 0- file is NOT opened on this member, other- opened */
	U8 frt_sector_logical; /* logical (!!!) sector in which file record resides */
	U8 frt_offset; /* offset within this frt sector */
	U8 fat_entry2; /* first sector (3 bytes) -- entry point for the FAT chain (0 when fd_file_struct member is unused, i.e. not pointing to a file) */
	U16 fat_entry; 
	U8 file_len2; /* file size (3 bytes) */
	U16 file_len;
	U8 ptr2; /* data pointer (3 bytes) */
	U16 ptr;
	U8 data_sector2; /* corresponding data sector (3 bytes) -- relative to the base of data area of the disk */
	U16 data_sector;
	U8 need_new_sector; /* when YES -- next write will be to allocate a new sector FIRST */
}PACKED;

struct fd_journal_struct{ //*** DO NOT RESHUFFLE THE ORDER OF MEMBERS -- ACCESS IN ASSEMBLY LANGUAGE (TDL#64) ***
	U16 sector_num; // number of cached sector
	U8 cache_num; //number of the sector in journal memory where "sector" is stored
};

struct file_rec_struct{
	U8 active; /* record active when =FRT_REC_ACTIVE_TAG */
	U8 len2; /* 3 bytes of file size */
	U16 len;
	U8 fat_entry2; /* number of the first data sector (beginning of fat chain) -- 3 bytes */
	U16 fat_entry; 
	U8 name_attr_len; /* length of the name/attributes string */
	U8 name_attr[56]; /* name/attributes string itself */
}PACKED;

#define FRT_REC_SIZE (sizeof(file_rec))
#define FAT_CACHE_SIZE 200
#define FILEREC_SIZE 64


namespace ntios {
namespace flashdisk {

class FD{
 public:
	FD();
	Property<U16, FD> availableflashspace{this, nullptr, &FD::availableflashspaceGetter,
							PropertyPermissions::Read};

	Property<U8, FD> buffernum{this, &FD::NumSetter, &FD::NumGetter,
						PropertyPermissions::ReadWrite};

	Property<U8, FD> filenum{this, &FD::FileNumSetter, &FD::FileNumGetter,
						PropertyPermissions::ReadWrite};

	Property<U32, FD> filesize{this, nullptr, &FD::filesizeGetter,
							PropertyPermissions::Read};

	Property<U32, FD> pointer{this, nullptr, &FD::pointerGetter,
							PropertyPermissions::Read};

	Property<no_yes, FD> transactionstarted{this, nullptr, &FD::transactionstartedGetter,
							PropertyPermissions::Read};

	Property<U8, FD> transactioncapacityremaining{this, nullptr, &FD::transactioncapacityremainingGetter,
							PropertyPermissions::Read};

	Property<U8, FD> maxopenedfiles{this, nullptr, &FD::maxopenedfilesGetter,
							PropertyPermissions::Read};

	Property<U16, FD> capacity{this, nullptr, &FD::capacityGetter,
							PropertyPermissions::Read};

	Property<no_yes, FD> ready{this, nullptr, &FD::readyGetter,
							PropertyPermissions::Read};

	Property<U8, FD> numservicesectors{this, nullptr, &FD::numservicesectorsGetter,
							PropertyPermissions::Read};	

	Property<U16, FD> totalsize{this, nullptr, &FD::totalsizeGetter,
							PropertyPermissions::Read};
	
	Property<pl_fd_status_codes, FD> laststatus{this, nullptr, &FD::laststatusGetter,
							PropertyPermissions::Read};
 
	Property<U8, FD> maxstoredfiles{this, nullptr, &FD::maxstoredfilesGetter,
							PropertyPermissions::Read};

	Property<U8, FD> fileopened{this, nullptr, &FD::fileopenedGetter,
							PropertyPermissions::Read};

	Property<U16, FD> sector{this, nullptr, &FD::sectorGetter,
							PropertyPermissions::Read};



	U16 setbuffer(std::string data, U16 offset);  
	std::string getbuffer(U16 offset,U16 len);
	pl_fd_status_codes setsector(U16 num); 
	pl_fd_status_codes getsector(U16 num); 
	ok_ng checksum(pl_fd_csum_mode mode, U16 csum);
	pl_fd_status_codes format(U16 totalsize, U8 numstoredfiles);
	pl_fd_status_codes formatj(U16 totalsize, U8 numstoredfiles,U8 maxjournalsectors);
	pl_fd_status_codes mount(void);   
	pl_fd_status_codes create(std::string name_attr);  
	pl_fd_status_codes open(std::string name);  	
	pl_fd_status_codes setpointer(U32 pos);  	
	pl_fd_status_codes setdata(std::string data);  	
	std::string getdata(U8 maxinplen);
	pl_fd_status_codes close(void);   
	pl_fd_status_codes flush(void);   
	pl_fd_status_codes setfilesize(U32 newsize);
	pl_fd_status_codes cutfromtop(U32 numsectors);
	pl_fd_status_codes Delete(std::string name);  	
	pl_fd_status_codes rename(std::string old_name,std::string new_name);  	
	pl_fd_status_codes setattributes(std::string name,std::string attr);  	
	std::string getattributes(std::string name);  	
	pl_fd_status_codes transactionstart(void);   
	pl_fd_status_codes transactioncommit(void);
	U8 getnumfiles(void);
	std::string getnextdirmember(void);  	
	void resetdirpointer(void);
	U32 find(U32 frompos, std::string substr, U16 instance, forward_back dir, U16 incr, pl_fd_find_modes mode);  
	U16 getfreespace(void);  


 private:
	U16 availableflashspaceGetter() const;
	void NumSetter(U8 num);
	U8 NumGetter() const;
	void FileNumSetter(U8 num);
	U8 FileNumGetter() const;
	U32 filesizeGetter() const;
	U32 pointerGetter() const;
	no_yes transactionstartedGetter() const;
	U8 transactioncapacityremainingGetter() const;
	U8 maxopenedfilesGetter() const;
	U16 capacityGetter() const;
	no_yes readyGetter() const;	
	U8 numservicesectorsGetter() const;	
	U16 totalsizeGetter() const;
	pl_fd_status_codes laststatusGetter() const;	
	U8 maxstoredfilesGetter() const;	
	U8 fileopenedGetter() const;	
	U16 sectorGetter() const;	
	


	int initialize_flash_disk();
	int initialize_linux_flash_disk();
	void tios_fd_init(void);
	unsigned short tios_api_fd_get_sector_count();
	U16 fl_rd_fr_buff(U16 offset, U32 data, U16 length);
	U16 fl_wr_to_buff(U16 offset, U32 data, U16 length);
	unsigned short read_write_buffer(int is_write, U16 offset, U8 *data, U16 length);
	U8 fl_wr_sect_fr_buff(U16 sect_number);
	U8 fl_rd_sect_to_buff(U16 sect_number);
	U8 spi_wr_rd_sector(U8 wr_rd_oper,U16 sect_num);
	U8 check_sector_number(U16 sect_num);
	unsigned char os_api_fd_read_write_sector(unsigned char is_write_operation, unsigned short sector_number);
	void send_b_r67_0(U8 comm_code,U16 sect_num);
	U8 wait_df_op_completed(void);
	U8 spi_flash_send_byte(U8 byte);
	U8 spi_flash_read_byte(void);
	int tios_api_fd_read(unsigned long offset, unsigned long length, unsigned char *data);
	int tios_api_fd_write(unsigned long offset, unsigned long length, const unsigned char *data);   
	fd_status_codes fd_format(U8 mode,U16 totalsize,U8 numstoredfiles,U8 maxjournalsectors);
	void clean_buffer(void);
	U8 fl_process_checksum(U8 mode, U32 cs_addr);
	void tios_api_fd_mount();
	void close_fd();
	int tios_api_lfd_copyfile(const char *f_src, const char *f_dst, unsigned long from_pos);
	U16 p2_random_65(void);
	void common_front_portion(std::string name_attr);
	void find_file(std::string name_attr);
	U8 comp_case_ins(U8 a, U8 b);
	void find_free_sector(void);
	void save_fat_sector(U8 x,U8 logical_sector);
	void save_frt_sector(U8 x,U8 logical_sector);
	void Flush();
	U32 p2_get_param24(U8 param2,U16 param) const;
	void p2_set_param24_note1(U8 *ptr2, U16 *ptr, U8 lim2, U16 lim,U32 value);
	void p2_set_param24_note1_b(U8 *ptr2, U16 *ptr, U8 lim2, U16 lim,U32 value);
	void p2_sub_3b(U8 *op_a_b3, U16 *op_a_word, U8 op_b_b3, U16 op_b_word);
	void get_next_sector_of_fat_chain(U8 mode);
	void copy_to_fd_file_temp(void);
	void copy_from_fd_file_temp();	
	void copy_fd_file(U32 dest, U32 src);
	void load_fat_sector(U16 logical_fat_sector);   
	void save_prev_sector();
	void p2_sum_3b(U8 *op_a_b3, U16 *op_a_word, U8 op_b_b3, U16 op_b_word);
	void sub_3b(U8 *op_a_b3, U16 *op_a_word, U8 op_b_b3, U16 op_b_word);
	void get_next_sector_of_fat_chain2(U8 mode);
	void load_fat_sector_save_prev(U16 logical_fat_sector);
	U8 p2_set_param24(U8 *ptr2, U16 *ptr, U8 lim2, U16 lim, U8 mode,U8 byte3);
	int tios_api_fd_transactionstart();
	int tios_api_fd_transactioncommit();
	void set_pointer_pos(U32 pos);		
	void get_next_sector_of_fat_chain_1(void); 
	void get_data(U8 offset);
	U8 compare(U8 *ptr1, U8 *ptr2, U8 len);
	U16 free_space(void);
	U8 Maxstoredfiles(void) const;
	

   
	U8 firmware_protection_on;
	U16 fl_size;
	U16 available_flash_space;
	U16 last_flash_sector;   
	U8 fd_ready;
	U16 fd_frt_size;
	U16 fd_fat_size;
	U16 fd_data_size;
	U8 fd_dir_sector;
	U8 fd_dir_offset;
	U8 fd_file_num;
	U8 fd_status_code;
	U8 fd_buf1_data_valid;
	U16 fd_buf1_curr_data_sector;
	U8 fd_norandom;
	U8 fd_leveling;
	U8 fd_error_data;
	U8 fd_buffer_num;
	U8 fd_journal_size;
	U8 fd_transactionstarted;
	U8 fd_num_journal_entries;
	U8 fd_next_available_journal_sect;
	struct fd_file_struct fd_file[FD_MAX_OPENED_FILES];
	struct fd_file_struct fd_file_temp;
	U8 fd_buf1_data_modified;
	struct fd_journal_struct fd_journal_entries[FD_MAX_JOURNAL_ENTRIES]; 
	U16 fd_journal_base;
	struct file_rec_struct file_rec;
	U8 frt_spare_len;
	U8 fat_spare_len;
	U8 frt_spare_ptr;
	U8 fat_spare_ptr;
	U8 frt_index_tab[MAX_REQ_FRT_SIZE];
	U8 fat_index_tab[MAX_REQ_FAT_SIZE];
	U8 frt_spare_tab[MAX_REQ_FRT_SIZE];
	U8 fat_spare_tab[MAX_REQ_FAT_SIZE];
	U8 fd_free_sect_srch_ptr_sect;	
	U8 fd_free_sect_srch_ptr_ofs;
	U8 unused_record_found,unused_record_sector,unused_record_offset;
	U8 target_record_found,target_record_sector,target_record_offset;
	U8 unused_sector_found,unused_sector_number_fat_sector,unused_sector_number_fat_offset;
	U16 unused_sector_number;	
	U16 fat_sector_prev;
	U16 fat_sector;
	U8 name_attr_len,name_len;
	U8 fat_sector_loaded;	
	U8 fat_sector_modified;
	U8 print_low_level_info;
	U16 pointer_pos; //3-byte value, used to pass file pointer position
	U8 pointer_pos2;
	U8 find_mode; //see enum find_modes
	U8 temp_str_len,temp_str[255]; //this string is used to read portions of data from the file
	U16 fat_cache[FAT_CACHE_SIZE]; //could not make the array of 255 members -- not enough memory
	U8 fat_cache_len, fat_cache_anchor2;
	U16 fat_cache_anchor;

};

}  // namespace flashdisk
}  // namespace ntios 

#endif  // STOR_NTIOS_FD_H_
