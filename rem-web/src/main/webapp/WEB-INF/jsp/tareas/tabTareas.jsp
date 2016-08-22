<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

var createTareasTab = function(){
	
	var respuestaNotificacion = function(tareaOriginal){
		
	    var label = new Ext.form.Label({
	    	text:'<s:message code="" text="**Descripcion" />'
	    });
	    var label2 = new Ext.form.Label({
	    	text:tareaOriginal
	    });
	    var btnOk = new Ext.Button({
			text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
			,handler:function(){
				win.close();
			}
		});
		var btnCancel= new Ext.Button({
			text:'<s:message code="app.botones.cancelar" text="**Cancelar" />'
			,handler:function(){
				win.close();
			}
		});
		var text = new Ext.form.TextArea({width:250});
		var buttonPanel = new Ext.Panel({
			layout:'column'
			,autoHeight:true
			,autoWidth:true
			,items:[{
				columnWidth:.5
				,items:btnOk
			},{
				columnWidth:.5
				,items:btnCancel
			}]
		});
		
		var contenido = new Ext.Panel({
				bodyStyle : 'padding:5px'
				,bodyBorder:false
				,layout:'anchor'
			,autoHeight:true
			,autoWidth:true
				,defaults:{
					border:false
					,style:'padding:5px'
				}
				,items : [
					{
						anchor:'100%'
						,items:label
					}
					,{
						anchor:'100%'
						,items:label2
					}
					,{
						anchor:'100%'
						,items:text
					}
					,{
						
						layout:'table'
						,style:'padding-top:10px;margin-left:30%'
						,items:[btnOk,{html:'&nbsp;',border:false},{html:'&nbsp;',border:false},btnCancel]
					}
				]
		});
		
		var win=new Ext.Window({
			title:'<s:message code="message" text="**Respuesta Notificacion" />'
			,modal:true
			,width:300
			,autoHeight:true
			,resizable:false
			,bodyBorder:false
			,items:[contenido]
		});
		win.show();
	};
	
	var verNotificacion = function(tareaOriginal,respuesta){
		var label = new Ext.form.Label({
	    	text:'<s:message code="" text="**Descripcion" />'
	    });
	    var label2 = new Ext.form.Label({
	    	text:tareaOriginal
	    });
		var label3 = new Ext.form.Label({
	    	text:respuesta
	    });
	    var btnOk = new Ext.Button({
			text:'<s:message code="app.botones.aceptar" text="**Aceptar" />'
			,handler:function(){
				win.close();
			}
		});
				
		var contenido = new Ext.Panel({
				bodyStyle : 'padding:5px'
				,bodyBorder:false
				,layout:'anchor'
			,autoHeight:true
			,autoWidth:true
				,defaults:{
					border:false
					,style:'padding:5px'
				}
				,items : [
					{
						anchor:'100%'
						,items:label
					}
					,{
						anchor:'100%'
						,items:label2
					}
					,{
						anchor:'100%'
						,items:label3
					}
					,{
						
						layout:'table'
						,style:'padding-top:10px;margin-left:40%'
						,items:[btnOk]
					}
				]
		});
		var win=new Ext.Window({
			title:'<s:message code="message" text="**Consulta Notificacion" />'
			,modal:true
			,width:300
			,autoHeight:true
			,resizable:false
			,bodyBorder:false
			,items:[contenido]
		});
		win.show();
		btnOk.focus();
	}
	
	var tareas=
		{tareas:[
		{id:'1',fecha:'20/07/2008',estado:'Respondido',descripcion:'detalles de la tarea',idEstado:'1'},
		{id:'2',fecha:'22/07/2008',estado:'No Leido',descripcion:'detalles de la tarea',idEstado:'0'}]};
	
	var tareasStore = new Ext.data.JsonStore({
	    	data: tareas
	    	,root: 'tareas'
	    	,fields: [
	    		,'id'
				,'idEstado'
	    		,{name:'fecha'}
	    		,'estado'
	    		,'descripcion'
	    	]
		});
		//ColumnModel para grids contratos
		var tareasCm= new Ext.grid.ColumnModel([
			{dataIndex: 'id',hidden:true,fixed:true},
			{dataIndex: 'idEstado',hidden:true, fixed:true},
		    {header: '<s:message code="tareas.fecha" text="**Fecha" />', width: 120,  dataIndex: 'fecha'},
		    {header: '<s:message code="tareas.estado" text="**Estado" />', width: 120,  dataIndex: 'estado'},
			{header: '<s:message code="tareas.descripcion" text="**Descripcion" />', width: 120, dataIndex: 'descripcion'}
			]
		);
	var tareasGrid= createGrid(tareasStore,tareasCm,{
			title:'<s:message code="tareas.titulo" text="**Tareas"/>'
			,style : 'margin-bottom:10px'
			//,width:500
			,autoWidth:true
			,iconCls : 'pfs_tabla'
	});
	var tareasGridListener =	function(grid, rowIndex, e) {
		
	    	var rec = grid.getStore().getAt(rowIndex);
			var estado=rec.get('idEstado');
			if (estado == 0) {
				//No respondido
				if(rec.get('descripcion')){
		    		var descripcion = rec.get('descripcion');
		    		respuestaNotificacion(descripcion);
					
			    	
		    	}	
			}else{
				verNotificacion('tarea Original','respuesta');
			}
	    	
	    };
	    
	tareasGrid.addListener('rowdblclick', tareasGridListener);
	
	
	var panel = new Ext.Panel({
		title:'<s:message code="tareas.titulo" text="**Tareas"/>'
		,style:'padding: 10px'
		,items:[
			tareasGrid
			]
	});


	return panel;
}