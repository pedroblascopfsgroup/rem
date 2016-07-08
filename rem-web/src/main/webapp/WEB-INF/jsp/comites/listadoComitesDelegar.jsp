<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var Comite = Ext.data.Record.create([
	      {name:'id'}
	      ,{name : 'nombre'}
	      ,{name : 'estado'}
	      ,{name : 'atrmin', type: 'float'}
	      ,{name : 'atrmax', type: 'float'}
          ,{name : 'pendientes'}
	      ,{name : 'prioridad'}
          ,{name : 'fechaVencimiento'}
	      ,{name : 'zona'}   
	   ]);

	var comitesStore = page.getStore({
       flow:'comites/listadoComitesADelegarData'
	   ,reader: new Ext.data.JsonReader({
	     root : 'comitesJSON'
	   } , Comite)
	  });
	  
	comitesStore.webflow({idExpediente:${idExpediente}});
	
	var gridComitesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="comiteusuario.listado.nombre" text="**Nombre"/>', width: 75, dataIndex : 'nombre'}
		,{header : '<s:message code="comiteusuario.listado.estado" text="**Estado"/>', width: 75, dataIndex : 'estado' }
		,{header : '<s:message code="comiteusuario.listado.atrmin" text="**Atribucion Minima"/>', width: 75, dataIndex : 'atrmin', renderer: app.format.moneyRenderer}
		,{header : '<s:message code="comiteusuario.listado.atrmax" text="**Atribucion Maxima"/>', width: 75, dataIndex : 'atrmax', renderer: app.format.moneyRenderer}
        ,{header : '<s:message code="comiteusuario.listado.puntospend" text="**Puntos Pendientes"/>', width: 75, dataIndex : 'pendientes'}
        ,{header : '<s:message code="comiteusuario.listado.prioridad" text="**Prioridad"/>', width: 75, dataIndex : 'prioridad', hidden:true}
        ,{header : '<s:message code="comiteusuario.listado.fvencim" text="**Fecha de Vencimiento"/>', width: 75, dataIndex : 'fechaVencimiento', autoWidth:true}
		,{header : '<s:message code="comiteusuario.listado.zona" text="**Zona"/>', width: 75, dataIndex : 'zona'}
		,{dataIndex:'id', hidden:true, fixed:true}
	]);

	var comiteSeleccionado = null;
	var comiteSeleccionadoNombre = null;

	var delegarButton = new Ext.Button({
		 text:'<s:message code="comite.delegar" text="**Delegar" />'
		,iconCls : 'icon_ok'
		,handler:function(){
			if (comiteSeleccionado==null){
				Ext.Msg.alert("No se puede ","El expediente ya se encuentra en el comité de máxima jerarquía");
			}else{
				Ext.Msg.confirm('<s:message code="expediente.delegarAComite" text="**Elevar a otro Comité" />', 
	                    	    '<s:message code="expediente.confirmacionDelegar"/> '+comiteSeleccionadoNombre,
	                    	       this.evaluateAndSend);
			}
		}	
		,evaluateAndSend:function(seguir){
			if (seguir==true || seguir=='yes'){
				page.webflow({
					 flow:'comites/elevarAComiteSuperior'
					,params:{idExpediente:${idExpediente},idComite:comiteSeleccionado}
					,success:function(){page.fireEvent(app.event.DONE);}
				});
			}
		}
	});
	
	var cancelarButton = new Ext.Button({
		 text:'<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler:function(){
			page.fireEvent(app.event.CANCEL);
		}	
	});


	var gridComitesGrid=new Ext.grid.GridPanel({
		title:'<s:message code="comiteusuario.listado.titulo" text="**default" />'
		,cm:gridComitesCm
		,store:comitesStore
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,style:'padding-top:10px'
		,viewConfig:{forceFit:true}
		,width:865
		,height:375
		,bbar : [delegarButton,cancelarButton ]
	});



	gridComitesGrid.on('rowclick', function(grid, rowIndex, e){
	   var rec = grid.getStore().getAt(rowIndex);
	   comiteSeleccionado = rec.get('id');	 
	   comiteSeleccionadoNombre = rec.get('nombre');  
	});

	var panel = new Ext.Panel({
	    items : [
	    	gridComitesGrid
	    ]
	    ,bodyStyle: 'padding: 10px'
		,height:400
		,width:900
	    ,border: false
	});
	//añadimos al padre y hacemos el layout
	page.add(panel);
	
	
</fwk:page>