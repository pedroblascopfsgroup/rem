<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){
	
	//DATOS REGISTRALES GRID de contratos
	

	<pfs:hidden name="porcentajeAcumulado" value=""/>
	
	var bienContrato = Ext.data.Record.create([
		  {name:'idContratoBien'}
		 ,{name:'idBien'}
		 ,{name:'idContrato'}
		 ,{name:'importeGarantizado'}
		 ,{name:'importeGarantizadoAprov'}
		 ,{name:'codRelacion'}
		 ,{name:'relacion'}
		 ,{name:'estado'}
		 ,{name:'codigoContrato'}
		 ,{name:'tipoProducto'}
		 ,{name:'diasIrregular'}
		 ,{name:'riesgo'}
		 ,{name:'titular'}
		 ,{name:'saldoVencido'}
		 ,{name:'estadoFinanciero'}
		 ,{name:'secuenciaGarantia'}
		 ,{name:'tipoProducto'}
		 ,{name:'situacion'}
		 ,{name:'usuarioExterno'}
    ]);

   	var bienContratosStore = page.getStore({
   		flow:'plugin/nuevoModeloBienes/bienes/NMBBienContratos'
       	,reader: new Ext.data.JsonReader({
        	root: 'contratosBien'
       	}, bienContrato)
   	});
    
   	bienContratosStore.webflow({idBien:${NMBbien.id}});    
 
var rendererSituacion =  function renderF(val){  if (val=="2"){ return "<s:message code="situacion.enAsunto" text="**En Asunto" />"; }else { return "<s:message code="situacion.expedimentado" text="**Expedientado" />";}};
 	var BienContratosCM  = new Ext.grid.ColumnModel([
         {header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idContratoBien" text="**idContratoBien"/>',width:52, sortable: true, dataIndex: 'idContratoBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idBien" text="**idBien"/>', sortable: true, dataIndex: 'idBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idContrato" text="**idContrato"/>', sortable: true, dataIndex: 'idContrato', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.numContrato" text="**Num. contrato"/>', sortable: true, dataIndex: 'codigoContrato'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.codRelacion" text="**cod relacion"/>', sortable: true, dataIndex: 'codRelacion', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.relacion" text="**relacion"/>', sortable: true, dataIndex: 'relacion'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.importeGarantizado" text="**importeGarantizado"/>', align:'right', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeGarantizado'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.importeGarantizadoAprov" text="**importeGarantizadoAprov"/>', align:'right', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'importeGarantizadoAprov'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.estado" text="**estado"/>', sortable: true, dataIndex: 'estado', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.producto" text="**Producto"/>', sortable: true, dataIndex: 'tipoProducto'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.diasVencido" text="**dias vencido"/>', sortable: true, dataIndex: 'diasIrregular', align:'right'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.saldoVencido" text="**Saldo vencido"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'saldoVencido', align:'right'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.riesgo" text="**riesgo"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'riesgo', align:'right'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.primerTitular" text="**titular"/>', sortable: true, dataIndex: 'titular'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.situacion" text="**situacion"/>', sortable: true, dataIndex: 'situacion',renderer:rendererSituacion}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.estadoFinanciero" text="**Estado financiero"/>', sortable: true, dataIndex: 'estadoFinanciero'}
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.otrosDatos.secGarantia" text="**Secuencia de la Garantía de la operación"/>', sortable: true, dataIndex: 'secuenciaGarantia'}
</sec:authorize>
    ]);
 
   
	
	
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		var btnNuevaRelacionContrato = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnNuevaRelacionContrato" text="**Nueva relación con contrato" />'
		    ,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
				var w = app.openWindow({
					flow : 'editbien/nuevaRelacionBienContrato'
					,width: 800
					,autoHeight: true
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titleNuevaRelacion" text="**Nueva relación" />'
					,params : {idBien:${NMBbien.id} }
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
		
		var btnEditarRelacionContrato = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnEditarRelacionContrato" text="**Editar relación" />'
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
		  
			    var rec = gridContratos.getSelectionModel().getSelected();
	            if (!rec) return;
	            var idContrato=rec.get("idContrato");
	            var codTipoContratoBien = rec.get("codRelacion");
		            
				var w = app.openWindow({
					flow : 'editbien/nuevaRelacionBienContrato'
					,width:700
					,height:500
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titleNuevaRelacion" text="**Nueva relación" />'
					,params : {	idBien:${NMBbien.id}
								,idContrato : idContrato
								,codTipoContratoBien : codTipoContratoBien
							  }
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
		
		var btnBorrarContrato = new Ext.Button({
		    text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){
				var rec = gridContratos.getSelectionModel().getSelected();
	            if (!rec) return;
	            var id=rec.get("idContratoBien");
				if (id){
					Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="app.borrarRegistro" text="**¿Seguro que desea borrar el registro?" />', this.decide, this);
				}
			}
			,decide : function(boton){
				if (boton=='yes'){ this.borrar(); }
			}
			,borrar : function(){
				var rec = gridContratos.getSelectionModel().getSelected();
	            if (!rec) return;
	            var id=rec.get("idContratoBien");
	            var params = {};
				params.id = id;
				page.webflow({
					flow : 'editbien/borrarRelacionBienContrato'
					,params : {id : id}
					,success : function() {
						bienContratosStore.webflow({idBien:${NMBbien.id}});
					 }
				});
			}
		});
	</sec:authorize>
	
	 var gridContratos = app.crearGrid(bienContratosStore, BienContratosCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.gridContratos.titulo" text="**Relación con Contratos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_contratos'
        ,height : 220
        ,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
        			btnNuevaRelacionContrato ,btnEditarRelacionContrato, btnBorrarContrato
        		</sec:authorize>]
    });
    
	gridContratos.on('rowdblclick',function(grid, rowIndex, e){
		var rec = gridContratos.getStore().getAt(rowIndex);
    	if(rec.get('idContrato') && !rec.get('usuarioExterno')){
    		var id = rec.get('idContrato');
    		var desc = rec.get('codigoContrato');
    		app.abreContrato(id,desc);
	  	}
	});
	
	
	//DATOS REGISTRALES GRID de personas
	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
		var btnNuevaRelacionPersona = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnNuevaRelacion" text="**Nueva relación con cliente" />'
		    ,iconCls : 'icon_mas'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
				var w = app.openWindow({
					flow : 'editbien/nuevaRelacionContrato'
					,width:700
					,height:500
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titleNuevaRelacion" text="**Nueva relación" />'
					,params : {idBien:${NMBbien.id},
							   tPorce:porcentajeAcumulado.getValue()}
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
		
		var btnEditarRelacionPersona = new Ext.Button({
		    text: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.btnEditarRelacion" text="**Editar relación" />'
		    ,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,style:'margin-left:2px;padding-top:0px'
		    ,handler:function(){
			    var rec = gridPersonas.getSelectionModel().getSelected();
	            if (!rec) return;
	            var idBien=rec.get("idBien");
	            var idPersona=rec.get("idPersona");
	            var porce=rec.get("participacion");
	            var apellidoNombre=rec.get("apellidoNombre");
		            
				var w = app.openWindow({
					flow : 'editbien/editaRelacionContrato'
					,width:700
					,height:500
					,title : '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titleNuevaRelacion" text="**Nueva relación" />'
					,params : {	idBien:idBien,
								idPersona:idPersona,
							   	porce:porce,
							   	tPorce:porcentajeAcumulado.getValue(),
							   	nomPersona:apellidoNombre
							  }
				});
				w.on(app.event.DONE, function(){
					w.close();
					app.abreBienTab(${NMBbien.id}, '${NMBbien.id}' + '${NMBbien.tipoBien.descripcion}', bienTabPanel.getActiveTab().initialConfig.nombreTab);
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
	        }
		});
	</sec:authorize>
	
	
	
	var bienPersona = Ext.data.Record.create([
		  {name:'idPersonaBien'}
		 ,{name:'idBien'}
		 ,{name:'idPersona'}
		 ,{name:'apellidoNombre'}
		 ,{name:'participacion'}
		 ,{name:'segmento'}
		 ,{name:'deudaIrregular'}
		 ,{name:'totalSaldo'}
		 ,{name:'deudaDirecta'}
		 ,{name:'numContratos'}
		 ,{name:'diasVencido'}
		 ,{name:'situacion'}
    ]);

   	var personasBienStore = page.getStore({
   		flow:'plugin/nuevoModeloBienes/bienes/NMBBienPersonas'
       	,reader: new Ext.data.JsonReader({
        	root: 'personasBien'
       	}, bienPersona)
   	});
    
   	personasBienStore.webflow({idBien:${NMBbien.id}});    
 
 	var BienPersonasCM  = new Ext.grid.ColumnModel([
         {header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idPersonaBien" text="**idPersonaBien"/>',width:52, sortable: true, dataIndex: 'idPersonaBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idBien" text="**idBien"/>', sortable: true, dataIndex: 'idBien', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.idPersona" text="**idPersona"/>', sortable: true, dataIndex: 'idPersona', hidden: true}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.apellidoNombre" text="**apellidoNombre"/>', sortable: true, dataIndex: 'apellidoNombre'}
        ,{header: '<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.participacion" text="**Participacion"/>', dataIndex: 'participacion', renderer: function (val){if (val=="---"){return "";} var result = app.format.formatNumber(val,2);return String.format("{0} %",result);}, align:'right'}
		,{header: '<s:message code="menu.clientes.listado.lista.segmento" text="**segmento"/>', sortable: true, dataIndex: 'segmento'}
		,{header: '<s:message code="menu.clientes.listado.lista.totaldeuda" text="**saldo vencido"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'deudaIrregular', align:'right'}
		,{header: '<s:message code="menu.clientes.listado.lista.totalsaldo" text="**Riesgo total"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'totalSaldo', align:'right'}
		,{header: '<s:message code="menu.clientes.listado.lista.riesgoDirecto" text="**Riesgo directo"/>', renderer: app.format.moneyRenderer, sortable: true, dataIndex: 'deudaDirecta', align:'right'}
		,{header: '<s:message code="menu.clientes.listado.lista.nrocontratos" text="**Contratos"/>', sortable: true, dataIndex: 'numContratos', align:'right'}
		,{header: '<s:message code="menu.clientes.listado.lista.posantigua" text="**Dias vencido"/>', sortable: true, dataIndex: 'diasVencido', align:'right'}
		,{header: '<s:message code="menu.clientes.listado.lista.situacionFinanciera" text="**Situación"/>', sortable: true, dataIndex: 'situacion'}
    ]);
 
 	<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
	 	var btnBorrarBien = new Ext.Button({
		    text : '<s:message code="app.borrar" text="**Borrar" />'
			,iconCls : 'icon_menos'
			,handler : function(){
				var rec = gridPersonas.getSelectionModel().getSelected();
	            if (!rec) return;
	            var id=rec.get("idPersonaBien");
				if (id){
					Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="app.borrarRegistro" text="**¿Seguro que desea borrar el registro?" />', this.decide, this);
				}
			}
			,decide : function(boton){
				if (boton=='yes'){ this.borrar(); }
			}
			,borrar : function(){
				var rec = gridPersonas.getSelectionModel().getSelected();
	            if (!rec) return;
	            var id=rec.get("idPersonaBien");
	            var params = {};
				params.id = id;
				page.webflow({
					flow : 'editbien/borrarRelacionContrato'
					,params : params || {}
					,success : function() {
						personasBienStore.webflow({idBien:${NMBbien.id}});
					 }
				});
			}
		});
	</sec:authorize>
		
    var gridPersonas = app.crearGrid(personasBienStore, BienPersonasCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.gridPersonas.titulo" text="**Relación con Clientes"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_cliente'
        ,height : 222
        ,bbar : [<sec:authorize ifAllGranted="SOLVENCIA_EDITAR">
        			btnNuevaRelacionPersona, btnEditarRelacionPersona, btnBorrarBien
        		</sec:authorize>]
    });
    
    personasBienStore.on('load', function(store, records, options) {
    	var acum = 0; 
	 	personasBienStore.each(function(record){   
			acum += record.get('participacion');
		}, this); 
		porcentajeAcumulado.setValue(acum);
	}); 
	
    gridPersonas.on('rowdblclick',function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
    	var nombre_cliente=rec.get('apellidoNombre');
    	app.abreCliente(rec.get('idPersona'), nombre_cliente);
	});
	
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titulo" text="**Relaciones"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [gridContratos, gridPersonas]
		,nombreTab : 'tabRelacionesBien'
	});
	
	return panel;
})()