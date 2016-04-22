
#DEFINE START_PATH      ADDBS(FULLPATH(CURDIR()))

#DEFINE DEFSTART_PATH   "D:\Tools\"

#DEFINE DEBUG_VERSION   VERSION(2) # 0 
#DEFINE APP_VERSION     ( VERSION(2) = 0  OR TYPE( "_SCREEN.IsAppSetV" ) = "L" )
#DEFINE RELEASE_VERSION VERSION(2) = 0 

#DEFINE THIS_PATH       ""

#DEFINE THIS_PATH_FRM   ""

#DEFINE VFPLIB_PATH     IIF( !DEBUG_VERSION,"","D:\VfpLib\")

&&-------------------------------------------------------

#DEFINE COLOR_HIGHLIGHT  RGB( 128, 128, 215 )

#DEFINE COLOR_LOWLIGHT   RGB( 128, 128, 192 )


&&-------------------------------------------------------

#DEFINE CR  CHR(13) + CHR(10 )
#DEFINE CRLF              CHR(13)+CHR(10) 

 
#DEFINE VFP8_VERSION       VERSION(5) >= 800
#DEFINE VFP6_VERSION       VERSION(5) <  800         && tuo paciu ir VFP 7 (za adno)

#DEFINE USEIN2_TEMP        RELEASE_VERSION 
#DEFINE USEIN_TEMP         .T.


#DEFINE ASSERT_MSG         ASSERT .F. MESSAGE  
#DEFINE ASSERT_DEB         ASSERT !DEBUG_VERSION MESSAGE  

&&------------------------------------------------------- 