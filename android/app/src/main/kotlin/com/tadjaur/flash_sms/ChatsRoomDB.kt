//package com.tadjaur.flash_sms
//
//import android.arch.persistence.room.*
//import android.content.Context
//
//@Database(entities = [Message::class], version = 1)
//abstract class ChatsRoomDB : RoomDatabase() {
//    abstract val messageDao: MessageDao
//
//    companion object {
//        @Volatile
//        private var INSTANCE: ChatsRoomDB? = null
//
//        fun getInstance(context: Context): ChatsRoomDB {
//            synchronized(this) {
//                var instance = INSTANCE
//                if (instance == null) {
//                    instance = Room.databaseBuilder(context, ChatsRoomDB::class.java, "flash_chats_db")
//                            .fallbackToDestructiveMigration()
//                            .build()
//                    INSTANCE = instance
//                }
//                return instance
//            }
//        }
//    }
//}
//
//@Entity(tableName = "message")
//class Message {
//    @PrimaryKey
//    var id: Int = 0
//
//    var phone: String? = null
//
//    var msg: String? = null
//
//    var status: Int? = null
//
//    var time: Long? = null
//}
//
//@Dao
//interface MessageDao {
//    @Insert(onConflict = OnConflictStrategy.REPLACE)
//    fun insertMessage(vararg msg: Message): Message
//
//    @Update
//    fun updateMessage(vararg msg: Message): Boolean
//
//    @Query("SELECT * FROM message ORDER BY time DESC")
//    fun loadAllMessages(): ArrayList<Message>
//
//    @Query("SELECT * FROM message WHERE id = :idx  LIMIT 1")
//    fun getMessageById(idx: Int): Message
//
//    @Query("SELECT * FROM message WHERE phone = :phone  ORDER BY time DESC")
//    fun loadByContact(phone: String): ArrayList<Message>
//
//}
