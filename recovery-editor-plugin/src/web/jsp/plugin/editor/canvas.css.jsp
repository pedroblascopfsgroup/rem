<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
body { font-family : Calibri,Tahoma; font-size : 12px ; background :#464446}
#esquema { padding:20px; margin-top:20px; overflow :   auto;width:5000px ; background: white}
#esquemawrap { margin-top:20px; overflow :   auto;margin-right:430px;}
.box {  padding : 5px; border: 1px solid #ccc; imargin :5px; float : left;position:relative; padding-right:45px; padding-right:5px; }
.arquetipo { background : #ccc; }
.condicion { background : #ddd; position : relative; cursor : pointer }
.or { background: white url(<fwk:context/>img/plugin/editor/fondo_or.gif) repeat-x; float:left ;border:3px solid #ccc; margin:auto; overflow:auto; padding : 5px; position: relative}
.and { border:2px solid #ccc; padding:5px; float:left ; margin:auto; overflow:auto;  position: relative; background : white url(<fwk:context/>img/plugin/editor/fondo_and.gif) repeat-x;}
.andSeparator {  clear:both; padding : 5px;width:20px;height:30px;border-right:3px solid #888}
.andSeparatorExtended {background: transparent url(<fwk:context/>img/plugin/editor/and_separator.gif) no-repeat top right;}
.orSeparator { float:left; padding : 5px;width:20px;height:3px;border-bottom:3px solid #888}
.orSeparatorExtended { background: transparent url(<fwk:context/>img/plugin/editor/or_separator.gif) no-repeat  5px 0px;}
.titulo_paquete { color: #777; font-weight : bolder; display:block; clear : both; margin-bottom:4px; text-decoration:none; outline : none }


.noborder { border : 2px solid white; background : transparent }

.edit, .addY, .addO, .eliminar { z-index : 1; border:1px solid #fff; position: absolute; top : 2px; font-weight:bolder; background:#bbb;color:white;padding:2px; font-size : 8px ; text-decoration : none}
.eliminar { right:2px;}
.condition_selected { border-color : red; }
.addY {right:12px; }
.addO {right:22px; }
.edit {right:32px;background:#aaf }
.condicion a:hover { background : red; }
.box { background : white url(<fwk:context/>img/plugin/editor/fondo_box.gif); }
.subarquetipo { background : white url(<fwk:context/>img/plugin/editor/blue.gif) repeat-x;}
.subarquetipo a { text-decoration:none; color:black;}
.subarquetipo a:hover { background:transparent; color : red ;}
.rojo {width:10px;height:10px;background:#faa;float:left;margin-top:5px; margin-right:5px}
.azul {width:10px;height:10px;background:#aaf;float:left;margin-top:5px; margin-right:5px}
.link { background : #cec; }

.bold { color:red; font-weight : bolder; }

#editorReglas {
   position : absolute;
   background : #eee;
   padding : 10px;
   right : 10px;
   top :   0px;
   width :  400px;
   height : 500px;
   iborder-left : 10px solid #ccc;
}
.number { width : 80px;}
.regla { margin-top : 10px; }
.regla input { border:1px solid #888; }



