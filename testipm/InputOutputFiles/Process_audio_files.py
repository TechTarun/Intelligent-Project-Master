from pydub import AudioSegment

track = AudioSegment.from_file("E:\\Projects\\IPM\\IPM-MainRepo\\InputOutputFiles\\1595613115404.m4a", "m4a")
output = track.export("E:\\Projects\\IPM\\IPM-MainRepo\\InputOutputFiles\\audio.wav", format="wav")