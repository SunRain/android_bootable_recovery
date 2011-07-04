// Settings Constants 
#define TW_MIN_SETTINGS_CHARS 1 // Max Character Length Per Line
#define TW_MAX_SETTINGS_CHARS 255 // Max Character Length Per Line
#define TW_MAX_NUM_SETTINGS 11 // Total Number of Settings (Change this as we add more settings)

static const char* TW_SETTINGS_FILE = "/sdcard/nandroid/.twrs"; // Actual File
static const int TW_VERSION = 0; // Used to make sure of settings compatability
static const int TW_SIGNED_ZIP = 1; // Zip Signed Toggle (Constant number corresponds to line number in file .twrs)
static const int TW_NAN_SYSTEM = 2; // system is backed up during nandroid (Constant number corresponds to line number in file .twrs)
static const int TW_NAN_DATA = 3; // data is backed up during nandroid (Constant number corresponds to line number in file .twrs)
static const int TW_NAN_CACHE = 4;
static const int TW_NAN_BOOT = 5;
static const int TW_NAN_WIMAX = 6;
static const int TW_NAN_RECOVERY = 7;
static const int TW_NAN_SDEXT = 8;
static const int TW_NAN_ANDSEC = 9;
static const int TW_ZIP_LOCATION = 10; // Last location zip flashed from (remembers last folder) (Constant number corresponds to line number in file .twrs)

static const char tw_version_val[] = "1.0.0"; // Variable Holding Version
static char tw_signed_zip_val[TW_MIN_SETTINGS_CHARS]; // Variable that holds value, default is defined
static char tw_nan_system_val[TW_MIN_SETTINGS_CHARS]; //
static char tw_nan_data_val[TW_MIN_SETTINGS_CHARS]; //
static char tw_nan_cache_val[TW_MIN_SETTINGS_CHARS];
static char tw_nan_boot_val[TW_MIN_SETTINGS_CHARS];
static char tw_nan_wimax_val[TW_MIN_SETTINGS_CHARS];
static char tw_nan_recovery_val[TW_MIN_SETTINGS_CHARS];
static char tw_nan_sdext_val[TW_MIN_SETTINGS_CHARS];
static char tw_nan_andsec_val[TW_MIN_SETTINGS_CHARS];
static char tw_zip_location_val[TW_MAX_SETTINGS_CHARS]; //

static char tw_nandroid_string[1024];

// Read Settings Function
int is_true(char* tw_setting);
void tw_set_defaults();
void write_s_file();
void read_s_file();

// Menus
void install_zip_menu();
void advanced_menu();

void usb_storage_toggle();
void wipe_dalvik_cache();

void save_up_a_level_menu_location(int up_location);

// Nandroid Menu Stuff
void nandroid_menu();
void nan_backup_menu();
void nan_restore_menu();
char* nan_img_set(int tw_setting);
void nandroid_string();