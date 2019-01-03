Master().reset()

IDEES GENERALES
phase I  " postrocky"
pad >> bass >> kraut

Clock.bpm = 90
Scale.default.set = "minor"

a1 >> klank((4,5))
b1 >> faim(var([1,[3,0],2],[6,1,1]), oct=3, dur=var([1/2,1/4],[6,2]), sus=s1.dur*0.7, hpf=160)
d1 >> play("<xx x><  O ><->").every([16,4], "amen").every(7, "jump")
s1 >> faim((b1.degree, var([0,[3,5]],[8,4])), dur=PDur([4,5],8), sus=s1.dur*0.8, amp=PStrum(8)*.7, room=1, mix=0.7)
s2 >> scratch(PRand(6), sus=8, vib=PRand(32), oct=[5,[7,6]]).spread()
d2 >> play("<X.><:=><..|o1|.><v >", amp=1).every(14.5, "jump")

PHASE II "TECHNO !!!"

Master().lpf=800
d_all.stop()
b1.stop()

b2 >> dbass(PSine(64)*0.2, lpf=900, dur=[1/2,1/4,1/2,1/4,1/2]).sometimes("dur.shuffle")
p1 >> prof(b2.degree, oct=(var([(3,4),[5,6]],[6,2])), dur=1/2, sus=p1.dur*0.7, lforate=[1,2,4], lfowidth=0.9)

Master().lpf=linvar([900,10000],[64,inf], start=now)
Clock.bpm=linvar([90,120],[64,inf], start=now)
Group(a1,s1,s2).stop()

d3 >> play("<k ><[--]:[---]:><--o->")
n1 >> play("..I.", drive=(0,0.9), sample=1, rate=(PWhite(-1,4)), amp=PBern(16), pan=linvar([-1,1],24))
d4 >> play("x(---([::]:[::::]))", amp=3, sample=([0,1,2],[1,2,4])).sometimes("stutter")
d5 >> play("X ", amp=2)

#### Autobahn !!!!  Pause clopes, bières, on discute du match de la veille #####

PHASE III

Phase Piano
#Transition à définir
d_all.stop()

v1 >> pianovel([0,4,4,3,[4,4,[2,3],[5,6]]], dur=PBeat("x x xxx xx"), amp=0.5, scale=Scale.minorPentatonic).only()
v2 >> pianovel(dur=v1.dur, oct=[6,5,5,4], scale=Scale.minorPentatonic, amp=0.3).follow(v1)
v3 >> pianovel(dur=PBeat(" x x   x  "), oct=[4, 4, 3, 4], scale=Scale.blues, amp=0.4, sus=0.1).follow(v2)
v4 >> pianovel(dur=v3.dur, oct=[7,6,5,5], scale=Scale.blues, sus=[0.1, 0.5], velocity=[120, PWhite(80, 100)], hard=0.4, amp=0.8).follow(v2)
v5 >> pasha(PZip([0, 4, 4], [3, 5, [6, 7]]), dur=8, sus=8, delay=0.5, scale=Scale.minorPentatonic, drive=1, shape=8, shapemix=0.2, lpf=2400).spread()

Group(v_all).lpf = 500

l1 >> pianovel(dur=1/2, oct=[2,3], scale=Scale.blues, velocity=[120, PWhite(80, 100)], hard=1)
l2 >> pianovel(dur=1/2, oct=[4,5,3,4], scale=Scale.blues, velocity=[120, PWhite(120, 100)], hard=[1, 1.4])
b3 >> dbass(dur=1/2, oct=[4,5,5,5.02], scale=Scale.blues, amp=3)

Group(v_all).lpf = 2500


d7 >> play("X:", amp=3)
Clock.bpm=linvar([120,180],[128,inf], start=now)
Group(v_all, l_all).stop()

Phase IV Dark teck

b9 >> dirt([0,0,0.5], dur=PDur(3,8), sus=1, chop=4, formant=var([0,1,PRand(8)],[4,3,1])).spread()
c1 >> play("T", dur=var([1/4,8],[8,1]), sample=P[:8])
d1 >> play("(x )( x)o{.vxX}")
d2 >> play("X:")
d2 >> play("<  * ><[--]>")
c8 >> play("#", rate=-1/2, hpf=3000, dur=4, room=1, coarse=[32,16,8,4]).spread()

Master().hpf=var([0,4000],[30,2])
Clock.bpm=var([120,60],[28,4])

d4 >> play("u", rate=-0.5, dur=PDur([3,5],8)*0.5, pshift=var(P[1:32],[1])+(0.1,0), room=1, shape=2, shapemix=0.5)
d5 >> play("V ", lpf=900)

Phase IV FINAL

####### Proposition 0, on tweak le tout pour faire crasher

##########Proposition I

b5 >> dbass((PSine(28)*PWhite(-0.4, 0.3), PSine(linvar([1, -1]))*2), amp=4, lpf=4500, dur=PDur([4, 5], 8)).spread()
b8 >> blip([0, 1, 3, 2], oct=(4,6), scale=Scale.diminished, dur=1/4, hpf=0, bpm=linvar([170, 190], [8]), drive=0.4, drivemix=0.4, amp=4, fmod=var([0, 4], [32]))
t1 >> play("N ", sample=1, dur=1/4, lfp=1020, bpm=linvar([120, 180], [8]))
t2 >> play("* ", dur=1/4, drive=0.01)
t3 >> play("X ", sample=2, lpf=120)
t4 >> bass([0, 1, 3, 2], scale=Scale.diminished, dur=1/2, bpm=linvar([120, 180], [8]))
t5 >> play("s ", dur=1/4, bpm=linvar([170, 190], [8]))
t6 >> play("v ", dur=1/4, bpm=linvar([120, 180], [8]))


### Proposition II
#à retravailler

n3 >> play("j", sample=4, amp=2, rate=(0.5 + PSine(16)/100,-0.25), drive=PWhite(0,0.2), chop=PWhite(0,4), dur=4, room=1, lpf=2900).spread()
b4 >> dbass(var([5,7,-2,2],16), dur=var([1/2,1/4],[12,4]), amp=1, lpf=900).every(8, "offadd", 2).every(12, "shufflets", 2)
q1 >> play(PEuclid2(3,8,"X","|=2|"), sample=1, drive=(0,0.8),rate=var([1,0.7],[16,2]),lpf=linvar([800,9800],[24,0]), lpr=linvar([1,0.05],[24,0])).often("stutter", Cycle([2,3,12]), amp=1).sometimes("amen")
q2 >> play("X:", amp=2, sample=2)
q3 >> play("<V(-[VX])V-><--I->", sample=3, amp=1, hpf=45).every(7, "stutter", Cycle([2, 3, 1, 2, 3, 4]))
r1 >> rave(dur=PDur(3,var([4,8],[4,5])), amp=2, slidefrom=PWhite(-0.5,0.5), lpf=linvar([900,2500],[8,0])).spread().rarely("offadd", 1, 0.75).degrade(0.2)
