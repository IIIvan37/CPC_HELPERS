include 'helpers/_helpers.asm'

module Test

action_1:
	SET_BORDER Color.fm_2
	ret

action_2:
	SET_BORDER Color.fm_3
	ret

action_3:
	SET_BORDER Color.fm_4
	ret

start
	di
	ld hl, #c9fb
	ld (#38), hl
	ei

	SET_MODE 0
	SET_COLOR 0, Color.fm_0
	WRITE_CRTC 6, 12
main_loop
	WAIT_VBL (void)

	// Première banque mémoire supplémentaire en #4000
	SET_BANK #C4
	
	// Mise à jour du buffer d'état clavier
	call Keyboard_scan

	// Affectation des action
	CHECK_ACTION Key_1, Test_action_1
                CHECK_ACTION Key_2, Test_action_2
	CHECK_ACTION Key_3, Test_action_3
	
	// Breakpoint winape ici
	WIN_BRK (void)

	halt
	halt


	jp main_loop
module off