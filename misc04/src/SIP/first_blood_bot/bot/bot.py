from pyVoIP.VoIP import VoIPPhone, PhoneStatus, CallState
import time
import wave

if __name__=="__main__":
    phone=VoIPPhone("65.108.149.3", 5060, "localphone", "WA33INAR7JDKUPNJ")
    phone.start()
    while(phone.get_status()!=PhoneStatus.REGISTERED and phone.get_status()!=PhoneStatus.FAILED):
        time.sleep(1)
    if(phone.get_status()==PhoneStatus.FAILED):
        phone.stop()
        exit(-1)
    
    call = phone.call('0000&PJSIP/6602') # Using the exploit as I don't want to make special cases 
    while(call.state!=CallState.ANSWERED and call.state!=CallState.ENDED):
        time.sleep(1)
    if(call.state==CallState.ENDED):
        phone.stop()
        exit(-1)
    print(call.state)
    f = wave.open('sounds/congratulations_start.wav', 'rb')
    frames = f.getnframes()
    data = f.readframes(frames)
    time.sleep(1)
    call.write_audio(data)
    stop = time.time() + (frames / 8000)  # frames/8000 is the length of the audio in seconds. 8000 is the hertz of PCMU.

    while time.time() <= stop and call.state == CallState.ANSWERED:
        time.sleep(0.1)

    f = wave.open('sounds/sanity_check.wav', 'rb')
    frames = f.getnframes()
    data = f.readframes(frames)
    time.sleep(1)
    call.write_audio(data)
    stop = time.time() + (frames / 8000)  # frames/8000 is the length of the audio in seconds. 8000 is the hertz of PCMU.

    while time.time() <= stop and call.state == CallState.ANSWERED:
        time.sleep(0.1)
    
    f = wave.open('sounds/congratulations_end.wav', 'rb')
    frames = f.getnframes()
    data = f.readframes(frames)
    time.sleep(1)
    call.write_audio(data)
    stop = time.time() + (frames / 8000)  # frames/8000 is the length of the audio in seconds. 8000 is the hertz of PCMU.

    while time.time() <= stop and call.state == CallState.ANSWERED:
        time.sleep(0.1)
    
    phone.stop()
    