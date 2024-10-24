For this challenge you are required to upload an APK to exploit the vulnerability in the provided APK. Your application
must have its package name as `it.ecsc2024.jeopardy.exploit` and a launchable activity at
`it.ecsc2024.jeopardy.exploit.MainActivity`.

The emulator runs Android 34 and installs the vulnerable application and then launches yours. It may require up to two
minutes to start therefore it is normal for the web page to return 500.

On systems with SELinux enabled, you may need to run `sudo setsebool -P selinuxuser_execheap 1` for the emulator to run
properly.
