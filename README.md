# *summer2021.bravo*

# **By Team Verification**

## DevOps
- Rob Wilson
- Michelle Monfort
- Jeroen Soeurt


## Team Bravo
- Alec Baileys
- Elshaday Mesfin 
- Tyler Puschinsky
- Ben Cushing

# Testing
To execute the integration tests, run the command following command (replace the DEVICE_ID with the appropriate device found with `adb devices`):
`flutter drive --driver=test_driver/integration_test_driver.dart --target=integration_test/integration_test.dart -d DEVICE_ID`

To grant microphone permissions:
`adb shell pm grant edu.umgc.harkify android.permission.RECORD_AUDIO`