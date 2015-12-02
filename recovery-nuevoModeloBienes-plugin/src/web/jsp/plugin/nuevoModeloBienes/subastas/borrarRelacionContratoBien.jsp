<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	<pfs:hidden name="porcentajeAcumulado" value=""/>
	
	var idBienes=new Array();
	<c:forEach var="id" items="${idBienes}"> 
		    idBienes.push(<c:out value="${id}"/>);
	</c:forEach>
	
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
		 ,{name:'tipoProducto'}
		 ,{name:'situacion'}
		 ,{name:'usuarioExterno'}
    ]);

   	var bienContratosStore = page.getStore({
   		flow:'subasta/getContratos'
       	,reader: new Ext.data.JsonReader({
        	root: 'contratosBien'
       	}, bienContrato)
   	});
    
   
   	bienContratosStore.webflow({idBienes:idBienes});  
 
 
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
    ]);
 
   
	
	
	
		
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
						bienContratosStore.webflow({idBienes:idBienes});
				}
			});
		 }
	 });
		
	 var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	 }); 	
 		
	
	
	 var gridContratos = app.crearGrid(bienContratosStore, BienContratosCM,{
        title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.gridContratos.titulo" text="**Relación con Contratos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,iconCls : 'icon_contratos'
        ,height : 220
        ,bbar : [btnBorrarContrato,btnCancelar]
        		
    });
    
	gridContratos.on('rowdblclick',function(grid, rowIndex, e){
		var rec = gridContratos.getStore().getAt(rowIndex);
    	if(rec.get('idContrato') && !rec.get('usuarioExterno')){
    		var id = rec.get('idContrato');
    		var desc = rec.get('codigoContrato');
    		app.abreContrato(id,desc);
	  	}
	});
	

	
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.nuevoModeloBienes.fichaBien.tabRelaciones.titulo" text="**Relaciones"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,items : [gridContratos]
		
	});
	
	page.add(panel);

</fwk:page>