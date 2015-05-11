<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(){


       //Panel propiamente dicho
       var panel =new Ext.Panel({
           title:'<s:message code="menu.clientes.consultacliente.contratosTab.title" text="**Contratos"/>'
           ,layout:'anchor'
           ,resizable:true
           ,height: 445
           ,bodyStyle : 'padding:10px'
   			,nombreTab : 'contratosPanel'        
       });
       
       
	panel.on('render', function()
	{


	    var limit = 10;
	
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
	    ]);
	    
	    
	
	    var contratoRiesgoDirecto = page.getStore({
	        eventName : 'listado'
	        ,limit:limit
	        ,flow:'clientes/contratosDeUnCliente'
	        ,reader: new Ext.data.JsonReader({
	            root: 'contratos'
	            ,totalProperty : 'total'
	        }, Contrato)
	    });
	   
	    var contratoRiesgoPasivo = page.getStore({
	        eventName : 'listado'
	        ,limit:limit
	        ,flow:'clientes/contratosDeUnCliente'
	        ,reader: new Ext.data.JsonReader({
	            root: 'contratos'
	            ,totalProperty : 'total'
	        }, Contrato)
	    });
	
	    var contratoRiesgoIndirecto = page.getStore({
	        eventName : 'listado'
	        ,limit:limit
	        ,flow:'clientes/contratosDeUnCliente'
	        ,reader: new Ext.data.JsonReader({
	            root: 'contratos'
	            ,totalProperty : 'total'
	        }, Contrato)
	    });
	
	
	
		function muestraDatosTitulo(store, grid, pasivo)
		{
			var total = store.getTotalCount();
			var rec = store.getAt(store.getRange().length-1);
	
			if (total == null || rec == null) return;
			
	        var saldoNoVencido = rec.get('saldoNoVencido');
	        var saldoVencido = rec.get('saldoIrregular');
	        var saldoPasivo = rec.get('saldoPasivo');
	        
	        //Recuperamos el texto del grid y recortamos a partir del caracter '[' para volver a generarle un nuevo texto
	        var texto = grid.title;
	        if (texto.indexOf('[') > 0)
	        	texto = texto.substring(0, texto.indexOf(' ['));
	        
	        texto += ' [';
	        var aux = '';
	        
	        aux = '<s:message code="cliente.tabContratos.textoTitulo.numeroContratos" text="**Num Contratos" />';
	        texto += aux + total+'.';
	        
	        if (pasivo == false)
	        {
		        if (saldoVencido != null)
		        {
		        	aux = '<s:message code="cliente.tabContratos.textoTitulo.saldoVencido" text="**Saldo Vencido" />';
		        	texto += aux+saldoVencido.toString().replace(".",",")+' &euro;.';
		        }
		        if (saldoNoVencido != null)
		        {
		        	aux = '<s:message code="cliente.tabContratos.textoTitulo.saldoNoVencido" text="**Saldo No Vencido" />';
		        	texto += aux+saldoNoVencido.toString().replace(".",",")+' &euro;.';
		        }
			}
			else
			{
		        	aux = '<s:message code="cliente.tabContratos.textoTitulo.saldoHaber" text="**Saldo Haber" />';
		        	texto += aux+saldoPasivo.toString().replace(".",",")+' &euro;.';
			}
			
		    texto += '&nbsp;]';
							
			grid.setTitle(texto);
		};
	
	
		contratoRiesgoDirecto.on('load', function(){muestraDatosTitulo(contratoRiesgoDirecto, riesgosDirectosGrid, false);});
		contratoRiesgoIndirecto.on('load', function(){muestraDatosTitulo(contratoRiesgoIndirecto, riesgosIndGrid, false);});
		contratoRiesgoPasivo.on('load', function(){muestraDatosTitulo(contratoRiesgoPasivo, riesgosDirectosPasivosGrid, true);});
	
	
	    var contratosRDCm= new Ext.grid.ColumnModel([
	            {header: '<s:message code="contratos.cc" text="**Codigo" />', width: 160,  dataIndex: 'cc', id:'colCodigoContrato'},
	            {header: '<s:message code="contratos.fechaDato" text="**Fecha dato" />', width: 160,  dataIndex: 'fechaDato', id:'colFechaDato'},
	            {header: '<s:message code="contratos.tipo" text="**Tipo" />', width: 120,  dataIndex: 'tipo'},
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
	            <app:test id="riesgosDirectosGrid" addComa="true" />
			,collapsed:false
			,collapsible:true
			,titleCollapse : true
			,dontResizeHeight: true
			,resizable:true
	            ,style : 'margin-bottom:10px;padding-right:10px'
	            ,height : 130
	            ,cls:'cursor_pointer'
	            ,iconCls : 'icon_contratos_vencidos'
	            ,bbar : [ fwk.ux.getPaging(contratoRiesgoDirecto) ]
				
	        });
	
			riesgosDirectosGrid.on('expand', function(){
				riesgosDirectosGrid.setHeight(340);				
					riesgosIndGrid.collapse(true);
					riesgosDirectosPasivosGrid.collapse(true);
				});
			
	
	        //Riesgos Directos PASIVOS
	        var riesgosDirectosPasivosGrid=app.crearGrid(contratoRiesgoPasivo,contratosRPCm,{
	            title:'<s:message code="menu.clientes.consultacliente.contratosTab.riesgosDirectosPasivo" text="**Riesgos Directos Pasivo"/>'
	            <app:test id="riesgosDirectosPasivosGrid" addComa="true" />
				,collapsed:false
				,collapsible:true
				,titleCollapse : true
				,resizable:true
				,dontResizeHeight: true
	            ,style : 'margin-bottom:10px;padding-right:10px'
	            ,height : 130
	            ,cls:'cursor_pointer'
	            ,iconCls : 'icon_contratos_pasivo'
	            ,bbar : [ fwk.ux.getPaging(contratoRiesgoPasivo) ]
	        });
	        	riesgosDirectosPasivosGrid.on('expand', function(){
					riesgosDirectosPasivosGrid.setHeight(340);				
					riesgosIndGrid.collapse(true);
					riesgosDirectosGrid.collapse(true);
				});
	        //contratos no vencidos
	        var riesgosIndGrid=app.crearGrid(contratoRiesgoIndirecto,contratosRICm,{
	            title:'<s:message code="menu.clientes.consultacliente.contratosTab.riesgosInd" text="**Riesgos Indirectos"/>'
	            <app:test id="riesgosIndGrid" addComa="true" />
				,collapsible:true
				,collapsed:false
				,titleCollapse : true
				,dontResizeHeight: true
				,resizable:true
	            ,style : 'margin-bottom:10px;padding-right:10px'
	            ,height : 130
	            ,cls:'cursor_pointer'
	            ,iconCls : 'icon_contratos'
	            ,bbar : [ fwk.ux.getPaging(contratoRiesgoIndirecto) ]
	        });
			riesgosIndGrid.on('expand', function(){
					riesgosIndGrid.setHeight(340);				
					riesgosDirectosPasivosGrid.collapse(true);
					riesgosDirectosGrid.collapse(true);
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
        

			panel.add(riesgosDirectosGrid);
			panel.add(riesgosIndGrid);
			panel.add(riesgosDirectosPasivosGrid);
			
			
		riesgosDirectosPasivosGrid.on('render', function(){
		    contratoRiesgoDirecto.webflow({idPersona:${id},tipoBusquedaPersona:0});
		    contratoRiesgoPasivo.webflow({idPersona:${id},tipoBusquedaPersona:1});
		    contratoRiesgoIndirecto.webflow({idPersona:${id},tipoBusquedaPersona:2});
		});			
			
		});
        
        
        return panel;
})()