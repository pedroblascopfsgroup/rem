<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad){

    var panel =new Ext.Panel({
        title:'<s:message code="menu.clientes.consultacliente.contratosTab.title" text="**Contratos"/>'
        ,layout:'anchor'
        ,resizable:true
        ,height: 545
        ,bodyStyle : 'padding:10px'
		,nombreTab : 'contratosPanel'        
    });

    var limit = 500;

    var Contrato = Ext.data.Record.create([
         {name:'id'}
        ,{name:'cc'}
        ,{name:'fechaDato'}
        ,{name:'tipo'}
        ,{name:'diasIrregular'}
        ,{name:'saldoNoVencido'}
        ,{name:'saldoIrregular'}
        ,{name:'idPersona'}
        ,{name:'otrosint'}
        ,{name:'apellido1'}
        ,{name:'apellido2'} 
        ,{name:'tipointerv'}
        ,{name:'fechaExtraccion'}
        ,{name:'moneda'}
        ,{name:'fechaPosVendida'}
        ,{name:'saldoDudoso'}
        ,{name:'fechaDudoso'}
        ,{name:'estadoFinanciero'}
        ,{name:'fechaEstadoFinanciero'}
        ,{name:'estadoFinancieroAnt'}
        ,{name:'fechaEstadoFinancieroAnt'}
        ,{name:'provision'}
        ,{name:'estadoContrato'}
        ,{name:'fechaEstadoContrato'}
        ,{name:'movIntRemuneratorios'}
        ,{name:'movIntMoratorios'}
        ,{name:'comisiones'}
        ,{name:'gastos'}
        ,{name:'fechaCreacion'}
        ,{name:'saldoPasivo'}
        ,{name:'condEspec'}
    ]);
    

	function getStore(name,flow){
      return page.getStore({
        eventName : 'listado'
        ,limit:limit
        ,flow:flow
        ,reader: new Ext.data.JsonReader({
            root: 'contratos'
            ,totalProperty : 'total'
            ,id: 'rowIndex'
        }, Contrato)
        ,storeId : name
       });
	}
    
    var contratoRiesgoDirecto =  getStore('contratoRiesgoDirectoStore',  'clientes/contratosDeUnCliente');
    var contratoRiesgoPasivo = getStore('contratoRiesgoPasivoStore', 'clientes/contratosDeUnCliente');
    var contratoRiesgoIndirecto = getStore('contratoRiesgoIndirecto ', 'clientes/contratosDeUnCliente');

	var tipoRiesgo={};
	tipoRiesgo.DIRECTO = 'riesgoDirecto';
	tipoRiesgo.INDIRECTO = 'riesgoIndirecto';
	tipoRiesgo.PASIVO = 'riesgoPasivo';
		
	contratoRiesgoDirecto.on('load', function(){muestraDatosTitulo(contratoRiesgoDirecto, riesgosDirectosGrid, false, tipoRiesgo.DIRECTO, data.numContratos);});
	contratoRiesgoIndirecto.on('load', function(){muestraDatosTitulo(contratoRiesgoIndirecto, riesgosIndGrid, false, tipoRiesgo.INDIRECTO, countContratos(contratoRiesgoIndirecto));});
	contratoRiesgoPasivo.on('load', function(){muestraDatosTitulo(contratoRiesgoPasivo, riesgosDirectosPasivosGrid, true, tipoRiesgo.PASIVO, contratoRiesgoPasivo.getTotalCount());});

    var contratosRDCm= new Ext.grid.ColumnModel([
            {header: '<s:message code="contratos.cc" text="**Codigo" />', width: 160,  dataIndex: 'cc', id:'colCodigoContrato'},
            {header: '<s:message code="contratos.fechaDato" text="**Fecha dato" />', width: 160,  dataIndex: 'fechaDato', id:'colFechaDato'},
            {header: '<s:message code="contratos.tipo" text="**Tipo" />', width: 120,  dataIndex: 'tipo'},
            {header: '<s:message code="contratos.condicionesEspeciales" text="**Disponible" />', width: 120,  dataIndex: 'condEspec',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.saldoirr" text="**Saldo Irregular" />', width: 120, dataIndex: 'saldoIrregular',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.saldotot" text="**Saldo No Vencido" />', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.diasirr" text="**Dias Irregular" />', width: 90,  dataIndex: 'diasIrregular'},
            {header: '<s:message code="contratos.otrosint" text="**Otros Intervinientes" />', width: 135,dataIndex: 'otrosint', id:'colOtrosInterv'},
            {header: '<s:message code="contratos.tipoint" text="**Tipo Intervencion" />', width: 135, dataIndex: 'tipointerv'},
            {header: '<s:message code="contratos.fExtraccion" text="**Fecha Extraccion" />', width: 135, dataIndex: 'fechaExtraccion', hidden:true},
            {header: '<s:message code="contratos.moneda" text="**Moneda Origen" />', width: 135, dataIndex: 'moneda', hidden:true},
            {header: '<s:message code="contratos.fPosVencida" text="**Fecha Pos Vencida" />', width: 135, dataIndex: 'fechaPosVendida', hidden:true},
            {header: '<s:message code="contratos.saldoDudoso" text="**Saldo Dudoso" />', width: 135, dataIndex: 'saldoDudoso', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fDudoso" text="**Fecha Dudoso" />', width: 135, dataIndex: 'fechaDudoso', hidden:true},
            {header: '<s:message code="contratos.estFinanc" text="**Estado Financ" />', width: 120, dataIndex: 'estadoFinanciero'},
            {header: '<s:message code="contratos.estFinancAnt" text="**Estado Financ Ant" />', width: 135, dataIndex: 'estadoFinancieroAnt', hidden:true},
            {header: '<s:message code="contratos.fEstFinanc" text="**Fecha Estado Finan" />', width: 135, dataIndex: 'fechaEstadoFinanciero', hidden:true},
            {header: '<s:message code="contratos.fEstFinancAnt" text="**Fecha Estado Finan Ant" />', width: 135, dataIndex: 'fechaEstadoFinancieroAnt', hidden:true}, 
            {header: '<s:message code="contratos.provision" text="**Provision" />', width: 135, dataIndex: 'provision', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.estado" text="**Estado Contrato" />', width: 135, dataIndex: 'estadoContrato', hidden:true},
            {header: '<s:message code="contratos.fEstado" text="**Fecha Estado Contrato" />', width: 135, dataIndex: 'fechaEstadoContrato', hidden:true},
            {header: '<s:message code="contratos.intRemun" text="**Intereses Remuneratorios Ptes" />', width: 135, dataIndex: 'movIntRemuneratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.intMorat" text="**Intereses Moratorios Ptes" />', width: 135, dataIndex: 'movIntMoratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.comisiones" text="**Comisiones" />', width: 135, dataIndex: 'comisiones', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.gastos" text="**Gastos" />', width: 135, dataIndex: 'gastos', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fCreacion" text="**Fecha Creacion" />', width: 135, dataIndex: 'fechaCreacion', hidden:true},
            {hidden:true, dataIndex: 'idPersona',fixed:true},
            {hidden:true, dataIndex:'id', fixed:true}
        ]
    );

    var contratosRPCm= new Ext.grid.ColumnModel([
            {header: '<s:message code="contratos.cc" text="**Codigo" />', width: 160,  dataIndex: 'cc', id:'colCodigoContrato'},
            {header: '<s:message code="contratos.fechaDato" text="**Fecha dato" />', width: 160,  dataIndex: 'fechaDato', id:'colFechaDato'},
            {header: '<s:message code="contratos.tipo" text="**Tipo" />', width: 120,  dataIndex: 'tipo'},
            {header: '<s:message code="contratos.condicionesEspeciales" text="**Disposicion" />', width: 120,  dataIndex: 'condEspec',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.pasivo.saldoirr" text="**Saldo Haber" />', width: 120, dataIndex: 'saldoPasivo',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.pasivo.saldotot" text="**Saldo Irregular" />', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right',hidden:true},
            {header: '<s:message code="contratos.diasirr" text="**Dias Irregular" />', width: 120,  dataIndex: 'diasIrregular'},
            {header: '<s:message code="contratos.otrosint" text="**Otros Intervinientes" />', width: 135,dataIndex: 'otrosint', id:'colOtrosInterv'},
            {header: '<s:message code="contratos.tipoint" text="**Tipo Intervencion" />', width: 135, dataIndex: 'tipointerv'},
            {header: '<s:message code="contratos.fExtraccion" text="**Fecha Extraccion" />', width: 135, dataIndex: 'fechaExtraccion', hidden:true},
            {header: '<s:message code="contratos.moneda" text="**Moneda Origen" />', width: 135, dataIndex: 'moneda', hidden:true},
            {header: '<s:message code="contratos.fPosVencida" text="**Fecha Pos Vencida" />', width: 135, dataIndex: 'fechaPosVendida', hidden:true},
            {header: '<s:message code="contratos.saldoDudoso" text="**Saldo Dudoso" />', width: 135, dataIndex: 'saldoDudoso', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fDudoso" text="**Fecha Dudoso" />', width: 135, dataIndex: 'fechaDudoso', hidden:true},
            {header: '<s:message code="contratos.estFinanc" text="**Estado Financ" />', width: 135, dataIndex: 'estadoFinanciero'},
            {header: '<s:message code="contratos.estFinancAnt" text="**Estado Financ Ant" />', width: 135, dataIndex: 'estadoFinancieroAnt', hidden:true},
            {header: '<s:message code="contratos.fEstFinanc" text="**Fecha Estado Finan" />', width: 135, dataIndex: 'fechaEstadoFinanciero', hidden:true},
            {header: '<s:message code="contratos.fEstFinancAnt" text="**Fecha Estado Finan Ant" />', width: 135, dataIndex: 'fechaEstadoFinancieroAnt', hidden:true},
            {header: '<s:message code="contratos.provision" text="**Provision" />', width: 135, dataIndex: 'provision', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.estado" text="**Estado Contrato" />', width: 135, dataIndex: 'estadoContrato', hidden:true},
            {header: '<s:message code="contratos.fEstado" text="**Fecha Estado Contrato" />', width: 135, dataIndex: 'fechaEstadoContrato', hidden:true},
            {header: '<s:message code="contratos.intRemun" text="**Intereses Remuneratorios Ptes" />', width: 135, dataIndex: 'movIntRemuneratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.intMorat" text="**Intereses Moratorios Ptes" />', width: 135, dataIndex: 'movIntMoratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.comisiones" text="**Comisiones" />', width: 135, dataIndex: 'comisiones', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.gastos" text="**Gastos" />', width: 135, dataIndex: 'gastos', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fCreacion" text="**Fecha Creacion" />', width: 135, dataIndex: 'fechaCreacion', hidden:true},
            {hidden:true, dataIndex: 'idPersona',fixed:true},
            {hidden:true, dataIndex:'id', fixed:true}
        ]
    );

    var contratosRICm= new Ext.grid.ColumnModel([
            {header: '<s:message code="contratos.cc" text="**Codigo" />', width: 170,  dataIndex: 'cc', id:'colCodigoContrato'},
            {header: '<s:message code="contratos.fechaDato" text="**Fecha dato" />', width: 160,  dataIndex: 'fechaDato', id:'colFechaDato'},
            {header: '<s:message code="contratos.tipo" text="**Tipo" />', width: 120,  dataIndex: 'tipo'},
            {header: '<s:message code="contratos.condicionesEspeciales" text="**Disposicion" />', width: 120,  dataIndex: 'condEspec',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.saldoirr" text="**Saldo Irregular" />', width: 120, dataIndex: 'saldoIrregular',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.saldotot" text="**Saldo No Vencido" />', width: 120,  dataIndex: 'saldoNoVencido',renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.diasirr" text="**Dias Irregular" />', width: 120,  dataIndex: 'diasIrregular'},
            {header: '<s:message code="contratos.otrosint" text="**Otros Intervinientes" />', width: 135,dataIndex: 'otrosint', id:'colOtrosInterv'},
            {header: '<s:message code="contratos.tipoint" text="**Tipo Intervencion" />', width: 135, dataIndex: 'tipointerv'},
            {header: '<s:message code="contratos.fExtraccion" text="**Fecha Extraccion" />', width: 135, dataIndex: 'fechaExtraccion', hidden:true},
            {header: '<s:message code="contratos.moneda" text="**Moneda Origen" />', width: 135, dataIndex: 'moneda', hidden:true},
            {header: '<s:message code="contratos.fPosVencida" text="**Fecha Pos Vencida" />', width: 135, dataIndex: 'fechaPosVendida', hidden:true},
            {header: '<s:message code="contratos.saldoDudoso" text="**Saldo Dudoso" />', width: 135, dataIndex: 'saldoDudoso', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fDudoso" text="**Fecha Dudoso" />', width: 135, dataIndex: 'fechaDudoso', hidden:true},
            {header: '<s:message code="contratos.estFinanc" text="**Estado Financ" />', width: 135, dataIndex: 'estadoFinanciero'},
            {header: '<s:message code="contratos.estFinancAnt" text="**Estado Financ Ant" />', width: 135, dataIndex: 'estadoFinancieroAnt', hidden:true},
            {header: '<s:message code="contratos.fEstFinanc" text="**Fecha Estado Finan" />', width: 135, dataIndex: 'fechaEstadoFinanciero', hidden:true},
            {header: '<s:message code="contratos.fEstFinancAnt" text="**Fecha Estado Finan Ant" />', width: 135, dataIndex: 'fechaEstadoFinancieroAnt', hidden:true},            
            {header: '<s:message code="contratos.provision" text="**Provision" />', width: 135, dataIndex: 'provision', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.estado" text="**Estado Contrato" />', width: 135, dataIndex: 'estadoContrato', hidden:true},
            {header: '<s:message code="contratos.fEstado" text="**Fecha Estado Contrato" />', width: 120, dataIndex: 'fechaEstadoContrato', hidden:true},
            {header: '<s:message code="contratos.intRemun" text="**Intereses Remuneratorios Ptes" />', width: 135, dataIndex: 'movIntRemuneratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.intMorat" text="**Intereses Moratorios Ptes" />', width: 135, dataIndex: 'movIntMoratorios', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.comisiones" text="**Comisiones" />', width: 135, dataIndex: 'comisiones', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.gastos" text="**Gastos" />', width: 135, dataIndex: 'gastos', hidden:true,renderer: app.format.moneyRenderer,align:'right'},
            {header: '<s:message code="contratos.fCreacion" text="**Fecha Creacion" />', width: 135, dataIndex: 'fechaCreacion', hidden:true},
            {hidden:true, dataIndex: 'idPersona',fixed:true},
            {hidden:true, dataIndex:'id', fixed:true}
        ]
    );


        
	//contratos vencidos
	var riesgosDirectosGrid=app.crearGrid(contratoRiesgoDirecto,contratosRDCm,{
		title:'<s:message code="menu.clientes.consultacliente.contratosTab.riesgosDirectos" text="**Riesgos Directos"/>'
		,style : 'margin-bottom:10px;padding-right:10px'
		,iconCls : 'icon_contratos_vencidos'
	});
	var riesgosDirectosPasivosGrid=app.crearGrid(contratoRiesgoPasivo,contratosRPCm,{
		title:'<s:message code="menu.clientes.consultacliente.contratosTab.riesgosDirectosPasivo" text="**Riesgos Directos Pasivo"/>'
		,style : 'margin-bottom:10px;padding-right:10px'
		,iconCls : 'icon_contratos_pasivo'
	});
	var riesgosIndGrid=app.crearGrid(contratoRiesgoIndirecto,contratosRICm,{
		title:'<s:message code="menu.clientes.consultacliente.contratosTab.riesgosInd" text="**Riesgos Indirectos"/>'
		,style : 'margin-bottom:10px;padding-right:10px'
		,iconCls : 'icon_contratos'
	});
	
	<c:if test="${!usuario.usuarioExterno}">
	var contratosGridListener = function(grid, rowIndex, e) {        
		var rec = grid.getStore().getAt(rowIndex);
		if(e.getTarget().className.indexOf('colCodigoContrato') != -1){
			//ABRO EL CONTRATO
			if (rec.get('id')){
				var cc = rec.get('cc');
				var id = rec.get('id');
				app.abreContrato(id, cc);
			}
		}else if(e.getTarget().className.indexOf('colOtrosInterv') != -1){
			//ABRO EL CLIENTE
			if (rec.get('idPersona')){
				var idPersona = rec.get('idPersona');
				var otrosint = rec.get('otrosint');
				app.abreCliente(idPersona, otrosint);
			}
		}
	   
	};
	
	riesgosIndGrid.addListener('rowdblclick', contratosGridListener);
	riesgosDirectosGrid.addListener('rowdblclick', contratosGridListener);
	riesgosDirectosPasivosGrid.addListener('rowdblclick', contratosGridListener);
	
	</c:if>
 
	entidad.cacheStore(riesgosDirectosGrid.getStore());
	entidad.cacheStore(riesgosIndGrid.getStore());
	entidad.cacheStore(riesgosDirectosPasivosGrid.getStore());

	panel.add(riesgosDirectosGrid);
	panel.add(riesgosIndGrid);
	panel.add(riesgosDirectosPasivosGrid);
		
		
	function crearGrid(store, columnModel, title, icon){
         return app.crearGrid(store,columnModel,{
            title:title
		      ,collapsed:false
		      ,collapsible:true
		      ,titleCollapse : true
		      ,dontResizeHeight: true
		      ,resizable:true
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,height : 130
            ,cls:'cursor_pointer'
            ,iconCls : icon
            ,bbar : [ fwk.ux.getPaging(store) ]
        });
	}

	function muestraDatosTitulo(store, grid, pasivo, tipo, total){
		var texto = '';
		// inicializar titulos
		switch(tipo){
			case tipoRiesgo.DIRECTO:
				texto = '<s:message code="menu.clientes.consultacliente.contratosTab.riesgosDirectos" text="**Riesgos Directos"/>';
				break;
			case tipoRiesgo.INDIRECTO:
				texto = aux = '<s:message code="menu.clientes.consultacliente.contratosTab.riesgosInd" text="**Riesgos Indirectos"/>';
				break;
			case tipoRiesgo.PASIVO:
				texto = '<s:message code="menu.clientes.consultacliente.contratosTab.riesgosDirectosPasivo" text="**Riesgos Directos Pasivo"/>';
				break;
		}
		grid.setTitle(texto);
			
		var rec = store.getAt(store.getRange().length-1);
		
		if (total == null || rec == null) return;
        var saldoNoVencido = rec.get('saldoNoVencido');
        var saldoVencido = rec.get('saldoIrregular');
        var saldoPasivo = rec.get('saldoPasivo');
        
        //Recuperamos el texto del grid y recortamos a partir del caracter '[' para volver a generarle un nuevo texto
        texto = grid.title;
        if (texto.indexOf('[') > 0) texto = texto.substring(0, texto.indexOf(' ['));
        texto += ' [';
        var aux = '';
        aux = '<s:message code="cliente.tabContratos.textoTitulo.numeroContratos" text="**Num Contratos" />';
        texto += aux + total+'.';
        if (pasivo == false){
	        if (saldoVencido != null){
	        	aux = '<s:message code="cliente.tabContratos.textoTitulo.saldoVencido" text="**Saldo Vencido" />';
	        	texto += aux+saldoVencido.toString().replace(".",",")+' &euro;.';
	        }
	        if (saldoNoVencido != null){
	        	aux = '<s:message code="cliente.tabContratos.textoTitulo.saldoNoVencido" text="**Saldo No Vencido" />';
	        	texto += aux+saldoNoVencido.toString().replace(".",",")+' &euro;.';
	        }
		}else{
	        aux = '<s:message code="cliente.tabContratos.textoTitulo.saldoHaber" text="**Saldo Haber" />';
	        texto += aux+saldoPasivo.toString().replace(".",",")+' &euro;.';
		}
		
	    texto += '&nbsp;]';
		grid.setTitle(texto);
	};
	
	function countContratos(store){
		var data = store.data;
		var items = data.items;
		var nContratos = 0;	
		for(var i=0;i < items.length;i++){
        	var item = items[i];
            var idContrato = item.json["id"];
            if(idContrato != null && idContrato != ""){
            	nContratos++;
            }
        }
        return nContratos;
	}

	panel.getValue = function(){ 
		return { 
			titulo1 : riesgosDirectosGrid.title,
			titulo2 : riesgosDirectosPasivosGrid.title,
			titulo3 : riesgosIndGrid.title
		};
	}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data,riesgosDirectosGrid.getStore(), {idPersona:data.id,tipoBusquedaPersona:0});
		entidad.cacheOrLoad(data,riesgosDirectosPasivosGrid.getStore(), {idPersona:data.id,tipoBusquedaPersona:1});
		entidad.cacheOrLoad(data,riesgosIndGrid.getStore(), {idPersona:data.id,tipoBusquedaPersona:2});
		var estado = entidad.get("contratosPanel");
		if (estado){
			riesgosDirectosGrid.setTitle(estado.titulo1);
			riesgosDirectosPasivosGrid.setTitle(estado.titulo2);
			riesgosIndGrid.setTitle(estado.titulo3);
		}
	}
	
	return panel;
})
