# Nim conversion of the user_created_sound.c FMOD Low Level API example

import math, os, strformat
import fmod

var
  currPhase = 0.0

proc pcmReadCallback(sound: ptr FmodSound, data: pointer,
                     datalen: cuint): FmodResult {.cdecl.} =

  # This is very important; without it we'd get random crashes!
  setupForeignThreadGc()

  const
    PHASE_INCREMENT = (2 * math.PI) / (44100.0 / 440.0)
    AMPLITUDE = 32767 / 4

  type Stereo16BitBuffer = ptr UncheckedArray[int16]
  var stereo16BitBuffer = cast[Stereo16BitBuffer](data)

  # 16 bit stereo (4 bytes per sample)
  for i in 0 ..< (datalen div 4):
      var v = (math.sin(currPhase) * AMPLITUDE).int16
      stereo16BitBuffer[i*2] = v      # left channel
      stereo16BitBuffer[i*2 + 1] = v  # right channel

      currPhase += PHASE_INCREMENT

  result = FMOD_OK


proc pcmSetPosCallback(sound: ptr FmodSound, subsound: cint, position: cuint,
                       postype: FmodTimeUnit): FmodResult {.cdecl.} =
  result = FMOD_OK


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
  mode = FMOD_OPENUSER or FMOD_LOOP_NORMAL or FMOD_CREATESTREAM
  exInfo: FmodCreateSoundExInfo

res = create(system.addr)
checkResult(res)

res = system.init(512, FMOD_INIT_NORMAL, nil)
checkResult(res)

exInfo.cbSize            = sizeof(FmodCreateSoundExInfo).int32
exInfo.numChannels       = 2                               # Number of channels in the sound.
exInfo.defaultFrequency  = 44100                           # Default playback rate of sound.
exInfo.decodeBufferSize  = 44100                           # Chunk size of stream update in samples. This will be the amount of data passed to the user callback.
exInfo.length            = (exinfo.defaultfrequency * exInfo.numChannels * sizeof(int16) * 5).uint32 # Length of PCM data in bytes of whole song (for Sound::getLength)
exInfo.format            = FMOD_SOUND_FORMAT_PCM16         # Data format of sound.
exInfo.pcmReadCallback   = pcmReadCallback                 # User callback for reading.
exInfo.pcmSetPosCallback = pcmSetPosCallback               # User callback for seeking.

res = system.createSound(nil, mode, exInfo.addr, sound.addr)
checkResult(res)

res = system.playSound(sound, nil, 0, channel.addr)
checkResult(res)

os.sleep(5000)

res = sound.release()
checkResult(res)

res = system.close()
checkResult(res)

res = system.release()
checkResult(res)

