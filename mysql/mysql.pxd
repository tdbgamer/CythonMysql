cdef extern from "mysql/mysql.h" nogil:
    ctypedef char const_char "const char"
    ctypedef struct MYSQL_STMT:
        pass
    ctypedef struct MYSQL:
        pass
    ctypedef unsigned long long my_ulonglong
    ctypedef char my_bool

    int MYSQL_NO_DATA
    int MYSQL_DATA_TRUNCATED

    ctypedef char ** MYSQL_ROW
    ctypedef struct MYSQL_RES:
        pass

    unsigned int NOT_NULL_FLAG
    unsigned int UNSIGNED_FLAG
    unsigned int NUM_FLAG

    unsigned long CLIENT_COMPRESS
    unsigned long CLIENT_FOUND_ROWS
    unsigned long CLIENT_MULTI_RESULTS
    unsigned long CLIENT_MULTI_STATEMENTS

    # Really, mysql? This magical value isn't defined anywhere?
    DEF CS_BINARY = 63

    enum mysql_option:
        MYSQL_INIT_COMMAND
        MYSQL_OPT_CONNECT_TIMEOUT
        MYSQL_OPT_READ_TIMEOUT
        MYSQL_OPT_WRITE_TIMEOUT
        MYSQL_OPT_LOCAL_INFILE
        MYSQL_OPT_NAMED_PIPE
        MYSQL_OPT_PROTOCOL
        MYSQL_READ_DEFAULT_FILE
        MYSQL_READ_DEFAULT_GROUP
        MYSQL_REPORT_DATA_TRUNCATION
        MYSQL_SECURE_AUTH
        MYSQL_SET_CHARSET_DIR
        MYSQL_SET_CHARSET_NAME
        MYSQL_SHARED_MEMORY_BASE_NAME
        MYSQL_OPT_READ_TIMEOUT
        MYSQL_OPT_WRITE_TIMEOUT
        MYSQL_OPT_USE_RESULT
        MYSQL_OPT_USE_REMOTE_CONNECTION
        MYSQL_OPT_USE_EMBEDDED_CONNECTION
        MYSQL_OPT_GUESS_CONNECTION
        MYSQL_SET_CLIENT_IP
        MYSQL_SECURE_AUTH
        MYSQL_REPORT_DATA_TRUNCATION
        MYSQL_OPT_RECONNECT
        MYSQL_OPT_SSL_VERIFY_SERVER_CERT

    enum mysql_protocol_type:
        MYSQL_PROTOCOL_DEFAULT
        MYSQL_PROTOCOL_TCP
        MYSQL_PROTOCOL_SOCKET
        MYSQL_PROTOCOL_PIPE
        MYSQL_PROTOCOL_MEMORY

    enum enum_field_types:
        MYSQL_TYPE_DECIMAL
        MYSQL_TYPE_TINY
        MYSQL_TYPE_SHORT
        MYSQL_TYPE_LONG
        MYSQL_TYPE_FLOAT
        MYSQL_TYPE_DOUBLE
        MYSQL_TYPE_NULL
        MYSQL_TYPE_TIMESTAMP
        MYSQL_TYPE_LONGLONG
        MYSQL_TYPE_INT24
        MYSQL_TYPE_DATE
        MYSQL_TYPE_TIME
        MYSQL_TYPE_DATETIME
        MYSQL_TYPE_YEAR
        MYSQL_TYPE_NEWDATE
        MYSQL_TYPE_VARCHAR
        MYSQL_TYPE_BIT
        MYSQL_TYPE_NEWDECIMAL
        MYSQL_TYPE_ENUM
        MYSQL_TYPE_SET
        MYSQL_TYPE_TINY_BLOB
        MYSQL_TYPE_MEDIUM_BLOB
        MYSQL_TYPE_LONG_BLOB
        MYSQL_TYPE_BLOB
        MYSQL_TYPE_VAR_STRING
        MYSQL_TYPE_STRING
        MYSQL_TYPE_GEOMETRY

    ctypedef struct MYSQL_BIND:
        enum_field_types buffer_type
        void *buffer
        unsigned long buffer_length
        unsigned long *length
        my_bool *is_null
        my_bool is_unsigned
        my_bool *error

    ctypedef struct MYSQL_TIME:
        unsigned int year, month, day, hour, minute, second
        unsigned long second_part

    ctypedef struct MYSQL_FIELD:
        char *name
        char *table
        unsigned int flags, length, max_length, decimals, charsetnr
        enum_field_types type

    MYSQL *mysql_init(MYSQL *)
    int mysql_options(MYSQL *, mysql_option, char *)
    my_bool mysql_ssl_set(MYSQL *, char *key, char *cert, char *ca,
                          char *capath, char *cipher)
    MYSQL *_mysql_real_connect "mysql_real_connect"(
            MYSQL *, char *host, char *user, char *passwd, char *db,
            unsigned int port, char *unix_socket, unsigned long client_flag)
    unsigned int mysql_errno(MYSQL *)
    char *mysql_error(MYSQL *)
    int _mysql_ping "mysql_ping"(MYSQL *)
    my_bool _mysql_commit "mysql_commit"(MYSQL *)
    my_bool _mysql_rollback "mysql_rollback"(MYSQL *)
    char *mysql_character_set_name(MYSQL *)
    int mysql_set_character_set(MYSQL *, char *csname)
    unsigned int mysql_warning_count(MYSQL *)
    void mysql_close(MYSQL *)

    MYSQL_STMT *mysql_stmt_init(MYSQL *)
    unsigned int mysql_stmt_errno(MYSQL_STMT *)
    char *mysql_stmt_error(MYSQL_STMT *)
    int _mysql_stmt_prepare "mysql_stmt_prepare"(MYSQL_STMT *,
                                                 char *stmt_str, unsigned long length)
    my_bool mysql_stmt_bind_param(MYSQL_STMT *, MYSQL_BIND *bind)
    my_bool mysql_stmt_bind_result(MYSQL_STMT *, MYSQL_BIND *bind)
    unsigned long mysql_stmt_param_count(MYSQL_STMT *)
    int _mysql_stmt_execute "mysql_stmt_execute"(MYSQL_STMT *)
    int _mysql_stmt_fetch "mysql_stmt_fetch"(MYSQL_STMT *)
    my_ulonglong mysql_stmt_affected_rows(MYSQL_STMT *)
    my_ulonglong mysql_stmt_insert_id(MYSQL_STMT *)
    my_bool _mysql_stmt_send_long_data "mysql_stmt_send_long_data"(MYSQL_STMT *,
                                                                   unsigned int parameter_number, char *data,
                                                                   unsigned long length)
    int _mysql_stmt_fetch_column "mysql_stmt_fetch_column"(MYSQL_STMT *,
                                                           MYSQL_BIND *bind, unsigned int column, unsigned long offset)
    int _mysql_stmt_store_result "mysql_stmt_store_result"(MYSQL_STMT *)
    my_bool mysql_stmt_free_result(MYSQL_STMT *)
    void mysql_stmt_close(MYSQL_STMT *)

    MYSQL_RES *mysql_stmt_result_metadata(MYSQL_STMT *)
    unsigned int mysql_num_fields(MYSQL_RES *)
    MYSQL_FIELD *mysql_fetch_field_direct(MYSQL_RES *, unsigned int fieldnr)
    MYSQL_FIELD *mysql_fetch_fields(MYSQL_RES *res)
    void mysql_free_result(MYSQL_RES *)

    int _mysql_real_query "mysql_real_query"(MYSQL *, char *stmt_str,
                                             unsigned long length)
    unsigned int mysql_field_count(MYSQL *)
    MYSQL_RES *_mysql_use_result "mysql_use_result"(MYSQL *)
    MYSQL_RES *_mysql_store_result "mysql_store_result"(MYSQL *)
    int _mysql_next_result "mysql_next_result"(MYSQL *)
    my_ulonglong mysql_insert_id(MYSQL *)
    my_ulonglong mysql_affected_rows(MYSQL *)
    MYSQL_ROW _mysql_fetch_row "mysql_fetch_row"(MYSQL_RES *)
    unsigned long *mysql_fetch_lengths(MYSQL_RES *)

    char *mysql_get_client_info()
    char *mysql_get_server_info(MYSQL *)
    char *mysql_get_ssl_cipher(MYSQL *)

    int mysql_library_init(int argc, char ** argv, char ** groups)

# cdef extern from "mysqld_error.h":
#     int ER_UNSUPPORTED_PS
