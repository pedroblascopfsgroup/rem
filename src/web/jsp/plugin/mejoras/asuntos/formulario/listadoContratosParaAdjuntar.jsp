<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

  var limit = 25;
  
  var idAsunto="${idAsunto}";
  var expediente="${expediente}";
  
  var contrato = Ext.data.Record.create([
	     {name : 'id' }
		,{name : 'bloquear' }
		,{name : 'codigoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'tipoProducto', sortType:Ext.data.SortTypes.asTex }
		,{name : 'saldoVencido', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'diasIrregular', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'riesgo', sortType:Ext.data.SortTypes.asFloat }
		,{name : 'titular', sortType:Ext.data.SortTypes.asTex }
		,{name : 'situacion', sortType:Ext.data.SortTypes.asTex}
		,{name : 'estadoContrato', sortType:Ext.data.SortTypes.asTex }
		,{name : 'estadoFinanciero', sortType:Ext.data.SortTypes.asTex }
	]);

    var contratosStore = page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,flow:'plugin.mejoras.asuntos.buscaContratosSinAsignar'
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
            header : '<s:message code="plugin.mejoras.asunto.formulario.listadoContratosParaAdjuntar.bloquear" text="**Bloquear" />'
            ,dataIndex : 'bloquear', width: 60
    });

    var contratosCm = new Ext.grid.ColumnModel([
			 {	dataIndex: 'id', hidden:true, fixed:true }
			,checkColumn
		    ,{	header: '<s:message code="listadoContratos.listado.contrato" text="**Num. Contrato"/>',sortable: false, width: 130, dataIndex: 'codigoContrato'}
		    ,{	header: '<s:message code="listadoContratos.listado.tipo" text="**Tipo"/>',sortable: false , dataIndex: 'tipoProducto'}
			,{	header: '<s:message code="listadoContratos.listado.dias" text="**D&iacute;as vencido"/>',sortable: false , width: 70, dataIndex: 'diasIrregular', align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.saldo" text="**Saldo vencido"/>',sortable: false , width: 70, dataIndex: 'saldoVencido', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.riesgo" text="**Riesgos"/>',sortable: false , width: 70, dataIndex: 'riesgo', renderer:app.format.moneyRenderer, align:'right'}
			,{	header: '<s:message code="listadoContratos.listado.primertitular" text="**1er Titular"/>',sortable: false , width:130, dataIndex: 'titular'}
			,{	header: '<s:message code="listadoContratos.listado.situacion" text="**Situacion"/>',sortable: false , width:60, dataIndex: 'situacion'}
		    ,{	header: '<s:message code="listadoContratos.listado.estado" text="**Estado"/>',sortable: false , width: 90, dataIndex: 'estadoContrato', hidden:true}
		    ,{	header: '<s:message code="listadoContratos.listado.estadoFinanciero" text="**Estado Financiero"/>',sortable: false , width: 90, dataIndex: 'estadoFinanciero'}
	]); 
	
	var pagingBar=fwk.ux.getPaging(contratosStore);
	
    var contratosGrid=app.crearGrid(contratosStore,contratosCm,{
        title:'<s:message code="plugin.mejoras.asunto.formulario.listadoContratosParaAdjuntar.grid.titulo" text="**Contratos del expediente"/>' + ": " + expediente
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
			if(datos.get('bloquear') == true) {
	      		numFilasSeleccionadas=numFilasSeleccionadas+1
			}
		}
		return numFilasSeleccionadas;
	}
	
	var obtenerSaldo=function(){
		var store = contratosGrid.getStore();
		var saldorecuperar=0;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('bloquear') == true) {
	      		saldorecuperar=saldorecuperar + datos.get('saldoVencido')
			}
		}
		return saldorecuperar;
	}
	
	var obtenerContratos=function() {
		var store = contratosGrid.getStore();
		var str = '';
		var datos;
		for (var i=0; i < store.data.length; i++) {
			datos = store.getAt(i);
			if(datos.get('bloquear') == true) {
				if(str!='') str += ',';
	      		str += datos.get('id');
			}
		}
		return str;
	}
	
	var adjuntar=function(seguir){
    	if(seguir== 'yes') {
			page.webflow({
	  			flow:'plugin.mejoras.procedimientos.bloquearContratosUpdate'
	  			,eventName: 'update'
	  			,params:{
	  				asunto:idAsunto
	  				,contratos:obtenerContratos()
	  				,saldorecuperar:obtenerSaldo()
	  			}
	  			,success: function(){
	       		    page.fireEvent(app.event.DONE);
	       		}
	  		});
	  	}
    }
    
	var btnBloquearContratos= new Ext.Button({
		text : '<s:message code="plugin.mejoras.asunto.formulario.listadoContratosParaAdjuntar.bloquearContratos" text="**Bloquear contratos seleccionados" />'
		,iconCls:'icon_menos'
		,cls: 'x-btn-text-icon'
		,handler : function(){
			if (comprobarSiHayFilSeleccionada()>=1){
				Ext.Msg.confirm('<s:message code="plugin.mejoras.asunto.formulario.listadoContratosParaAdjuntar.confirmacion" text="**Bloquear contratos" />', '<s:message code="plugin.mejoras.procedimiento.bloquearContrato.formulario.button.bloquear.confirmar" text="**¿Está seguro que desea bloquear los contratos seleccionados?" />',adjuntar);
	      	}else{
	      		Ext.Msg.alert('<s:message code="plugin.mejoras.procedimiento.bloquearContrato.formulario.informacion" text="**Información"/>','<s:message code="plugin.mejoras.procedimiento.bloquearContrato.formulario.sinSeleccion" text="**Debe seleccionar algún contrato"/>')
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
		,bbar: [ '->',btnBloquearContratos,btnCancelar ]
	});

	page.add(mainPanel);

    contratosStore.webflow({idAsunto:${idAsunto}});	
	
	</fwk:page>