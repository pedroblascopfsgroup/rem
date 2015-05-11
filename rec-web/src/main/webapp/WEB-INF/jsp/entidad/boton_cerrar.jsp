<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
new Ext.Button({
	text:'<s:message code="app.cerrarTabs" text="**Cerrar todo" />'
	,iconCls:'icon_cerrar'
	,handler:function(){
		if (app.entidad.entidades){
			//vamos a poner un panel delante que diga que no hay nada abierto
			// porque las entidades optimizadas TIENEN paneles ocultos, y si cerramos todas las pestanyas visibles
			// quedaran visibles
			/*if (!Ext.getCmp("todoVacio")){
				app.contenido.add(new Ext.Panel({
				  id :"todoVacio"
				  ,noCerrar : true //este tab tampoco lo cerramos
				}));
			}*/

			var todoVacio = Ext.getCmp("todoVacio");
			app.contenido.hideTabStripItem(todoVacio);
			app.contenido.setActiveTab(todoVacio);

			for(var i=0;i<app.entidad.entidades.length;i++){
				app.entidad.cerrarTodo.apply(app.entidad.entidades[i]);
			}	
		}
		var hideInternalTab = function(){
			//console.debug("hideInternalTab")
/*
		    var ntabs=app.contenido.items.getCount();
		   	var tab = app.contenido.items.get(ntabs-1);
*/
			var tab = getSiguienteTab();
			var nodos = tab.el.select('.x-tab-panel');
			//console.debug("hideInternalTab tab="+tab+ " nodos="+nodos + "nodos.len="+nodos.elements.length)
		   	if (nodos && nodos.elements.length>0 && nodos.elements[0].id && Ext.getCmp(nodos.elements[0].id)){
		   		var t = Ext.getCmp(nodos.elements[0].id);
				//console.debug("tab interno t="+t.el.dom);
			   	if (t.items.getCount()==0){
			   		app.contenido.remove(tab);
			   		return;
			   	}
			   	var tabInt = t.items.get(t.items.getCount()-1);
	            tabInt.on('destroy', function(){
	                	setTimeout( hideInternalTab, 30);
	            });
				t.remove(tabInt);
		   	}
		}

		var getSiguienteTab = function(){
            var ntabs=app.contenido.items.getCount();
			var tab;
			 while(ntabs-->0){
				//console.debug("ntabs", ntabs);
				tab = app.contenido.items.get(ntabs);
				 if (tab.el && !tab.initialConfig.noCerrar) return tab;
			}
		}
		
		//cierra los tabs de forma escalonada para que IE no se estrese
		var hideOneTab = function(){
			//console.debug("hideOneTab");
/*          var ntabs=app.contenido.items.getCount();
            if (ntabs==0) {
                app.contenido.el.unmask();
                return;
            }

			var tab = app.contenido.items.get(ntabs-1);
*/
			var tab = getSiguienteTab();
			//console.debug("tabb",tab);
			if (!tab){
				//console.debug("ya no hay tab");
                app.contenido.el.unmask();
                return;
			}
			//console.debug("tab", tab);
            tab.on('destroy', function(){
               	setTimeout( hideOneTab, 30);
            });
            var nodos = tab.el.select('.x-tab-panel'); 
			//console.debug("nodos", nodos);
			if (nodos && nodos.elements.length>0 && nodos.elements[0].id && Ext.getCmp(nodos.elements[0].id).items.getCount()>0){
				//console.debug("nodosid", nodos.elements[0].id);
				setTimeout(hideInternalTab, 10);
			}else{
				app.contenido.remove(tab);
			}
			
		}
		
        if (app.contenido.items.getCount()> 0){
            app.contenido.el.mask('<s:message code="app.cerrandoTabs" text="**tareas pendientes"/>');
        }
        setTimeout(hideOneTab,100);
	}
})
