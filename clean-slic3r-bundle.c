#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char *filter[] = {
    "[print:0.05mm ULTRADETAIL]",
    "[print:0.05mm ULTRADETAIL 0.25 nozzle]",
    "[print:0.05mm ULTRADETAIL 0.25 nozzle MK3]",
    "[print:0.05mm ULTRADETAIL MK3]",
    "[print:0.10mm DETAIL]",
    "[print:0.10mm DETAIL 0.25 nozzle]",
    "[print:0.10mm DETAIL 0.25 nozzle MK3]",
    "[print:0.10mm DETAIL 0.6 nozzle MK3]",
    "[print:0.10mm DETAIL MK3]",
    "[print:0.15mm 100mms Linear Advance]",
    "[print:0.15mm 100mms Linear Advance MK2.5]",
    "[print:0.15mm OPTIMAL]",
    "[print:0.15mm OPTIMAL 0.25 nozzle]",
    "[print:0.15mm OPTIMAL 0.25 nozzle MK3]",
    "[print:0.15mm OPTIMAL 0.6 nozzle]",
    "[print:0.15mm OPTIMAL 0.6 nozzle MK3]",
    "[print:0.15mm OPTIMAL MK2.5]",
    "[print:0.15mm OPTIMAL MK3]",
    "[print:0.15mm OPTIMAL MK3 SOLUBLE FULL]",
    "[print:0.15mm OPTIMAL MK3 SOLUBLE INTERFACE]",
    "[print:0.15mm OPTIMAL SOLUBLE FULL]",
    "[print:0.15mm OPTIMAL SOLUBLE FULL MK2.5]",
    "[print:0.15mm OPTIMAL SOLUBLE INTERFACE]",
    "[print:0.15mm OPTIMAL SOLUBLE INTERFACE MK2.5]",
    "[print:0.20mm 100mms Linear Advance]",
    "[print:0.20mm 100mms Linear Advance MK2.5]",
    "[print:0.20mm FAST 0.6 nozzle MK3]",
    "[print:0.20mm FAST MK3]",
    "[print:0.20mm FAST MK3 SOLUBLE FULL]",
    "[print:0.20mm FAST MK3 SOLUBLE INTERFACE]",
    "[print:0.20mm NORMAL]",
    "[print:0.20mm NORMAL 0.6 nozzle]",
    "[print:0.20mm NORMAL MK2.5]",
    "[print:0.20mm NORMAL SOLUBLE FULL]",
    "[print:0.20mm NORMAL SOLUBLE FULL MK2.5]",
    "[print:0.20mm NORMAL SOLUBLE INTERFACE]",
    "[print:0.20mm NORMAL SOLUBLE INTERFACE MK2.5]",
    "[print:0.35mm FAST]",
    "[print:0.35mm FAST 0.6 nozzle]",
    "[print:0.35mm FAST MK2.5]",
    "[print:0.35mm FAST sol full 0.6 nozzle]",
    "[print:0.35mm FAST sol int 0.6 nozzle]",
    "[filament:ColorFabb Brass Bronze]",
    "[filament:ColorFabb HT]",
    "[filament:ColorFabb PLA-PHA]",
    "[filament:ColorFabb Woodfil]",
    "[filament:ColorFabb XT]",
    "[filament:ColorFabb XT-CF20]",
    "[filament:ColorFabb nGen]",
    "[filament:ColorFabb nGen flex]",
    "[filament:E3D Edge]",
    "[filament:E3D PC-ABS]",
    "[filament:Fillamentum ABS]",
    "[filament:Fillamentum ASA]",
    "[filament:Fillamentum CPE HG100 HM100]",
    "[filament:Fillamentum Timberfil]",
    "[filament:Generic ABS]",
    "[filament:Generic ABS MMU2]",
    "[filament:Generic PET]",
    "[filament:Generic PET MMU2]",
    "[filament:Generic PLA]",
    "[filament:Generic PLA MMU2]",
    "[filament:My Settings]",
    "[filament:Polymaker PC-Max]",
    "[filament:Primavalue PVA]",
    "[filament:Prusa ABS]",
    "[filament:Prusa ABS MMU2]",
    "[filament:Prusa HIPS]",
    "[filament:Prusa PET]",
    "[filament:Prusa PET MMU2]",
    "[filament:Prusa PLA]",
    "[filament:Prusa PLA MMU2]",
    "[filament:Prusament PET MMU2]",
    "[filament:Prusament PETG]",
    "[filament:Prusament PLA]",
    "[filament:Prusament PLA MMU2]",
    "[filament:SemiFlex or Flexfill 98A]",
    "[filament:Taulman Bridge]",
    "[filament:Taulman T-Glase]",
    "[filament:Verbatim BVOH]",
    "[filament:Verbatim BVOH MMU2]",
    "[filament:Verbatim PP]",
    "[printer:My Settings]",
    "[printer:Original Prusa i3 MK2]",
    "[printer:Original Prusa i3 MK2 0.25 nozzle]",
    "[printer:Original Prusa i3 MK2 0.6 nozzle]",
    "[printer:Original Prusa i3 MK2 MMU1]",
    "[printer:Original Prusa i3 MK2 MMU1 0.6 nozzle]",
    "[printer:Original Prusa i3 MK2 MMU1 Single]",
    "[printer:Original Prusa i3 MK2 MMU1 Single 0.6 nozzle]",
    "[printer:Original Prusa i3 MK2.5]",
    "[printer:Original Prusa i3 MK2.5 0.25 nozzle]",
    "[printer:Original Prusa i3 MK2.5 0.6 nozzle]",
    "[printer:Original Prusa i3 MK2.5 MMU2]",
    "[printer:Original Prusa i3 MK2.5 MMU2 Single]",
    "[printer:Original Prusa i3 MK3]",
    "[printer:Original Prusa i3 MK3 0.25 nozzle]",
    "[printer:Original Prusa i3 MK3 0.6 nozzle]",
    "[printer:Original Prusa i3 MK3 MMU2]",
    "[printer:Original Prusa i3 MK3 MMU2 Single]",
    NULL
};

static char buf[10*1024*1024];

int
main(int argc, char **argv)
{
    int emitting = 0;

    while (fgets(buf, sizeof(buf), stdin) != NULL) {
	if (buf[0] == '[') {
	     const char **p;

	     for (p = filter; *p && strncmp(buf, *p, strlen(*p)) != 0; p++) {}
	     emitting = (*p == NULL);\
	}
	if (emitting) printf("%s", buf);
    }

    exit(0);
}
