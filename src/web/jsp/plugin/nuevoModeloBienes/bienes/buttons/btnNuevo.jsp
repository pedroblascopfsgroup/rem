<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

	new Ext.Button({
         text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnNuevoBien" text="**Nuevo bien" />'
        ,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
        ,handler:function(){
			var w = app.openWindow({
				flow : 'editbien/nuevoBien'
				,width:760
				,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.btnNuevoBien" text="**Nuevo bien" />' 
			});
			w.on(app.event.DONE, function(args){
				w.close();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
        }
	})

		
		