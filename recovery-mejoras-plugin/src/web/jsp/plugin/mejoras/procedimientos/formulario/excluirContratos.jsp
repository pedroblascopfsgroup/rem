<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var limit = 25;
    
    var contrato = Ext.data.Record.create([
	     {name : 'id' }
		,{name : 'excluir' }
		,{name : 'codigoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'tipoProducto', sortType:Ext.data.SortTypes.asTex }
		,{name : 'saldoIrregular', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'diasIrregular', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'riesgo', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'titular', sortType:Ext.data.SortTypes.asTex }
		,{name : 'situacion', sortType:Ext.data.SortTypes.asTex}
		,{name : 'estadoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'estadoFinanciero', sortType:Ext.data.SortTypes.asTex }
		,{name : 'pase', sortType:Ext.data.SortTypes.asTex }
		,{name : 'cex', sortType:Ext.data.SortTypes.asTex }
	]);

    var contratosStore = page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,storeId:'contratoProcedimientoStore'
        ,flow:'plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.listadoContratosExcluir'
        ,reader: new Ext.data.JsonReader({
            root: 'contratos'
            ,totalProperty : 'total'
        }, contrato)
    });
	
	Ext.grid.CheckColumn = function(config){
			    Ext.apply(this, config);
			    if(!this.id){
			        this.id = Ext.id();
			    }
			    this.renderer = this.renderer.createDelegate(this);
			};

			Ext.grid.CheckColumn.prototype ={
			    init : function(grid){
			        this.grid = grid;
			        this.grid.on('render', function(){
			            var view = this.grid.getView();
			            view.mainBody.on('mousedown', this.onMouseDown, this);
			        }, this);
			    },

			    onMouseDown : function(e, t){
			        if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
			            e.stopEvent();
			            var index = this.grid.getView().findRowIndex(t);
			            var record = this.grid.store.getAt(index);
			            record.set(this.dataIndex, !record.data[this.dataIndex]);
			        }
			    },
			
			    renderer : function(v, p, record){
			        p.css += ' x-grid3-check-col-td'; 
			        return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
			};
			
	var checkColumn = new Ext.grid.CheckColumn({ 
            header : '<s:message code="plugin.mejoras.listadoContratos.listado.excluir" text="**Excluir" />'
            ,dataIndex : 'excluir', width: 70
    });
		            
    var contratosCm = new Ext.grid.ColumnModel([
			 {	dataIndex: 'id', hidden:true, fixed:true }
			,checkColumn
		    ,{	header: '<s:message code="listadoContratos.listado.contrato" text="**Num. Contrato"/>',sortable: false, width: 130, dataIndex: 'codigoContrato'}
		    ,{	header: '<s:message code="listadoContratos.listado.tipo" text="**Tipo"/>',sortable: false , dataIndex: 'tipoProducto'}
			,{	header: '<s:message code="listadoContratos.listado.dias" text="**D&iacute;as vencido"/>',sortable: false , width: 70, dataIndex: 'diasIrregular', align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.saldo" text="**Saldo vencido"/>',sortable: false , width: 70, dataIndex: 'saldoIrregular', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.riesgo" text="**Riesgos"/>',sortable: false , width: 70, dataIndex: 'riesgo', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.primertitular" text="**1er Titular"/>',sortable: false , width:130, dataIndex: 'titular'}
			,{	header: '<s:message code="listadoContratos.listado.situacion" text="**Situacion"/>',sortable: false , width:60, dataIndex: 'situacion'}
		    ,{	header: '<s:message code="listadoContratos.listado.estado" text="**Estado"/>',sortable: false , width: 90, dataIndex: 'estadoContrato', hidden:true}
		    ,{	header: '<s:message code="listadoContratos.listado.estadoFinanciero" text="**Estado Financiero"/>',sortable: false , width: 90, dataIndex: 'estadoFinanciero'}
		    ,{	header: '<s:message code="plugin.mejoras.listadoContratos.listado.pase" text="**Pase"/>',sortable: false , width: 90, dataIndex: 'pase'}
	]); 

	var pagingBar=fwk.ux.getPaging(contratosStore);
	
    var contratosGrid=app.crearGrid(contratosStore,contratosCm,{
        title:'<s:message code="procedimiento.tabContratos.grid.titulo" text="**Contratos del procedimiento"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,height : 400
        ,cls:'cursor_pointer'
        ,plugins:checkColumn
        ,bbar : [pagingBar]
        ,iconCls : 'icon_contratos_vencidos'
    });

	var comprobarSiHayFilSeleccionada=function(){
		var store = contratosGrid.getStore();
		var datos;
		var numFilasSeleccionadas=0;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('excluir') == true) {
	      		numFilasSeleccionadas=numFilasSeleccionadas+1
			}
		}
		return numFilasSeleccionadas;
	}
	
	var comprobarSihayPase=function(){
		var store = contratosGrid.getStore();
		var datos;
		var numContratosPase=0;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('excluir') == true) {
	      		if (datos.get('pase')=="Sí") numContratosPase=numContratosPase+1
			}
		}
		return numContratosPase;
	}
	
	var obtenerPasePrincipal=function(){
		var store = contratosGrid.getStore();
		var datos;
		var importeContratoPase=0;
		var idContrato;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
      		if (datos.get('pase')=="Sí") {
      			if (datos.get('riesgo') != "" && importeContratoPase < datos.get('riesgo')) {
      				importeContratoPase=datos.get('riesgo');
      				codigoContrato=datos.get('codigoContrato')
      			}
      		}
		}
		return codigoContrato;
	}
	
	var comprobarSiSeIncluyePasePrincipal=function(){
		var store = contratosGrid.getStore();
		var datos;
		var importeContratoPase=0;
		var codigoContrato=obtenerPasePrincipal();
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('excluir') == true) {
	      		if (datos.get('pase')=="Sí") {
					if (datos.get('codigoContrato')==codigoContrato){
						return true;
					}
	      		}
			}
		}
		return false;
	}
	
	function paramsCex() {
		var store = contratosGrid.getStore();
		var str = '';
		var datos;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('excluir') == true) {
				if(str!='') str += ',';
	      		str += datos.get('cex');
			}
		}
		return str;
	}
	
    var excluir=function(seguir){
    	if(seguir== 'yes') {
			page.webflow({
	  			flow:'plugin/mejoras/procedimientos/plugin.mejoras.procedimientos.excluirContratoUpdate'
	  			,eventName: 'update'
	  			,params:{
	  				idProcedimiento:'${idProcedimiento}'
	  				,cexs:paramsCex()}
	  				,success: function(){
	       		   page.fireEvent(app.event.DONE);
	       		}
	  		});
	  	}
    }
    
    // No se permite excluir:
    // - el contrato de pase principal si se seleccionan varios de pase
    // - si solo existe un contrato de pase no se puede eliminar
	var btnExcluir = new Ext.Button({
		text : '<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.button.excluir" text="**Excluir contratos seleccionados" />'
		,iconCls:'icon_menos'
		,cls: 'x-btn-text-icon'
		,handler : function(){
			if (comprobarSiHayFilSeleccionada()>=1){
				if (comprobarSihayPase()==0) {
					Ext.Msg.confirm('<s:message code="expedientes.consulta.tabcabecera.otrosCont.excluirContratos" text="**Excluir contrato" />', '<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.button.excluir.confirmar" text="**¿Está seguro que desea excluir los contratos seleccionados?" />',excluir);
				}else{
					if (comprobarSiSeIncluyePasePrincipal()){
						Ext.Msg.alert('<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.informacion" text="**Información"/>','<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.eliminarContratoPasePrincipal" text="**No puede eliminar el contrato de pase principal:"/>' + " " + obtenerPasePrincipal())
					}else{
						Ext.Msg.confirm('<s:message code="expedientes.consulta.tabcabecera.otrosCont.excluirContratos" text="**Excluir contrato" />', '<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.button.excluir.confirmar" text="**¿Está seguro que desea excluir los contratos seleccionados?" />',excluir);
					}
				}
	      	}else{
	      		Ext.Msg.alert('<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.informacion" text="**Información"/>','<s:message code="plugin.mejoras.procedimiento.excluirContrato.formulario.sinSeleccion" text="**Debe seleccionar algún contrato"/>')
	      	}
		}
	});

	var btnCancelar = new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});

	var mainPanel = new Ext.form.FormPanel({
		autoHeight:true
		,bodyStyle:'padding:0px;'
		,border: false
	    ,items : [{
			bodyStyle:'padding:5px;cellspacing:10px'
			,border:false
			,defaults : {xtype:'panel' ,cellCls : 'vtop'}
			,items : [contratosGrid]
		  }]
		,bbar: [ '->',btnExcluir,btnCancelar ]
	});

	page.add(mainPanel);
    
    contratosStore.webflow({idProcedimiento:${idProcedimiento}});	
	
	</fwk:page>