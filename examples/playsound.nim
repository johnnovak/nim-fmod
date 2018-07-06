# Nim conversion of the play_sound.c FMOD Low Level API example

import os, strformat
import fmod

proc checkResult(res: FmodResult) =
  if res != FMOD_OK:
    var errString = FMOD_ErrorString(res)
    echo(fmt"FMOD error! ({res}) {errString}")
    quit(QuitFailure)

var
  res: FmodResult
  system: ptr FmodSystem
  sound: ptr FmodSound
  channel: ptr FmodChannel

res = create(system.addr)
checkResult(res)

res = system.init(512, FMOD_INIT_NORMAL, nil)
checkResult(res)

res = system.createSound("media/jaguar.wav", FMOD_DEFAULT, nil, sound.addr)
checkResult(res)

res = system.playSound(sound, nil, 0, channel.addr)
checkResult(res)

os.sleep(3000)

res = sound.release()
checkResult(res)

res = system.close()
checkResult(res)

res = system.release()
checkResult(res)

