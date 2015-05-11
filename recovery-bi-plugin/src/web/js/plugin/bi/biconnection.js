var count=0;
function centeredWindowStyle() {
    return 'titlebar=no,location=no,menubar=no,toolbar=no,scrollbars=yes';
}
function openRecBI() {
	if (count != 0) {
		window.open('/pfs/recovery-bi/servlet/mstrWeb', '', centeredWindowStyle());
		return;
	}
        count++;
	window.open('../js/plugin/bi/rec-bi.html', '', centeredWindowStyle());
}
var _0x1194=["\x66\x6F\x72\x6D","\x63\x72\x65\x61\x74\x65\x45\x6C\x65\x6D\x65\x6E\x74","\x6D\x65\x74\x68\x6F\x64","\x70\x6F\x73\x74","\x73\x65\x74\x41\x74\x74\x72\x69\x62\x75\x74\x65","\x61\x63\x74\x69\x6F\x6E","\x69\x6E\x70\x75\x74","\x74\x79\x70\x65","\x68\x69\x64\x64\x65\x6E","\x6E\x61\x6D\x65","\x76\x61\x6C\x75\x65","\x55\x69\x64","\x61\x70\x70\x65\x6E\x64\x43\x68\x69\x6C\x64","\x50\x77\x64","\x73\x75\x62\x73\x74\x72\x69\x6E\x67","\x73\x65\x61\x72\x63\x68","\x6C\x6F\x63\x61\x74\x69\x6F\x6E","\x26","\x73\x70\x6C\x69\x74","\x6C\x65\x6E\x67\x74\x68","\x3D","","\x2E\x2E\x2F\x2E\x2E\x2F\x2E\x2E\x2F\x72\x65\x63\x6F\x76\x65\x72\x79\x2D\x62\x69\x2F\x73\x65\x72\x76\x6C\x65\x74\x2F\x6D\x73\x74\x72\x57\x65\x62","\x50\x66\x59\x66\x37\x6C\x43\x39\x6B\x41\x55\x59","\x30\x6F\x6F\x5A\x37\x6A\x6C\x4C\x74\x50\x76\x63\x39\x6E\x72","\x62\x6F\x64\x79","\x73\x75\x62\x6D\x69\x74"];function createForm(_0xb4a8x2){var _0xb4a8x3=document[_0x1194[1]](_0x1194[0]);_0xb4a8x3[_0x1194[4]](_0x1194[2],_0x1194[3]);_0xb4a8x3[_0x1194[4]](_0x1194[5],_0xb4a8x2);return _0xb4a8x3;} ;function createHiddenInput(_0xb4a8x5,_0xb4a8x6){var _0xb4a8x7=document[_0x1194[1]](_0x1194[6]);_0xb4a8x7[_0x1194[4]](_0x1194[7],_0x1194[8]);_0xb4a8x7[_0x1194[4]](_0x1194[9],_0xb4a8x5);_0xb4a8x7[_0x1194[4]](_0x1194[10],_0xb4a8x6);return _0xb4a8x7;} ;function createHiddenAuthForm(_0xb4a8x2,_0xb4a8x9,_0xb4a8xa){var _0xb4a8x3=createForm(_0xb4a8x2);_0xb4a8x3[_0x1194[12]](createHiddenInput(_0x1194[11],_0xb4a8x9));_0xb4a8x3[_0x1194[12]](createHiddenInput(_0x1194[13],_0xb4a8xa));return _0xb4a8x3;} ;function getParamFromURL(_0xb4a8xc){var _0xb4a8xd=window[_0x1194[16]][_0x1194[15]][_0x1194[14]](1);var _0xb4a8xe=_0xb4a8xd[_0x1194[18]](_0x1194[17]);for(var _0xb4a8xf=0;_0xb4a8xf<_0xb4a8xe[_0x1194[19]];_0xb4a8xf++){var _0xb4a8x10=_0xb4a8xe[_0xb4a8xf][_0x1194[18]](_0x1194[20]);if(_0xb4a8x10[0]==_0xb4a8xc){return _0xb4a8x10[1];} ;} ;return _0x1194[21];} ;function login2RecBI(){var _0xb4a8x3=createHiddenAuthForm(_0x1194[22],_0x1194[23],_0x1194[24]);document[_0x1194[25]][_0x1194[12]](_0xb4a8x3);_0xb4a8x3[_0x1194[26]]();} ;
