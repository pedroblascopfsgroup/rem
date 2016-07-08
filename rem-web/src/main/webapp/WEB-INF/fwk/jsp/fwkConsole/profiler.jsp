<%@ page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fwk:page>

	
	var Stats = new Ext.data.Record.create([
		{name : 'Label'}
		,{name : 'Hits', type:'float'}
		,{name : 'Avg', type:'float'}
		,{name : 'Max', type:'float'}
		,{name : 'Min', type:'float'}
		,{name : 'StdDev', type:'float'}
		,{name : 'LastValue', type:'float'}
		,{name : 'FirstAccess'}
		,{name : 'LastAccess'}
		,{name : 'Total', type:'float'}
	]);

	var gridStore = page.getStore({
		flow : 'profiler/profilerData'
		,reader : new Ext.data.JsonReader({
			root : 'statistics'
		},Stats)
		,remoteSort : false
	});

	gridStore.webflow();

	var gridCm = new Ext.grid.ColumnModel([
		{header : 'Label', dataIndex : 'Label', sortable:true, width:200 }
		,{header : 'Hits', dataIndex : 'Hits', sortable:true, width:30 }
		,{header : 'Total', dataIndex : 'Total', sortable:true, width:50 }
		,{header : 'Min', dataIndex : 'Min', sortable:true, width:50 }
		,{header : 'Max', dataIndex : 'Max', sortable:true, width:50 }
		,{header : 'Avg', dataIndex : 'Avg', sortable:true, width:50 }
		,{header : 'StdDev', dataIndex : 'StdDev', width:50 }
		,{header : 'LastValue', dataIndex : 'LastValue' , sortable:true, width:50}
		,{header : 'FirstAccess', dataIndex : 'FirstAccess' , sortable:true, width:70}
		,{header : 'LastAccess', dataIndex : 'LastAccess', sortable:true, width:70}
	]);

	var botonRefresh = new Ext.Button({
		text : 'Refresh'
		,iconCls : 'fwk_recargar'
		,handler:function(){
			gridStore.webflow();
        }
	});

	var botonEnableDisable = new Ext.Button({
		text : 'Enable Statistics'
		,iconCls : 'icon_ok'
		,handler:function(){
			var w = app.openWindow({
						flow : 'profiler/changeStatisticsMode'
						,width:760
					});
			w.close();
			gridStore.webflow();
			if(this.getText()=='Disable Statistics'){
				this.setIconClass('icon_ok');
				this.setText('Enable Statistics');
			}else{
				this.setIconClass('icon_cancel');
				this.setText('Disable Statistics');
			}
        }
	});

	var botonReset = new Ext.Button({
		text : 'Clear Cache'
		,iconCls : 'icon_menos'
		,handler:function(){
			var w = app.openWindow({
						flow : 'profiler/reset'
						,width:760
						,title : 'Borrando cache' 
					});
			w.close();
			gridStore.webflow();
        }
	});
	
	var graphStore = new Ext.data.JsonStore({
		autoLoad: true
		,url: '/${appProperties.appName}/bam/data.htm?monitor=consoleChart'
		,root: 'data'
		,fields: ['name', {name: 'time', type: 'date'}, 'count', 'avg']
	});
	
	<!-- Timer -->
	var stop = false;
	var task = {
	    run: function(){
	        if(!stop){
	           graphStore.reload();
	        }else{
	            runner.stop(task); // we can stop the task here if we need to.
	        }
	    },
	    interval: 2000
	};
	var runner = new Ext.util.TaskRunner();
	//runner.start(task);

	// Using TaskMgr
	Ext.TaskMgr.start({
	    run: function(){
	    },
	    interval: 2000
	});
	<!-- End Timer -->	
	
	var graphPanel = new Ext.Panel({
		border: false
		,width: 700
		,height: 400
        ,items: [{
            xtype: 'columnchart'
            ,store: graphStore
            ,xField: 'time'
            ,yField: 'count'
            ,xAxis: new Ext.chart.TimeAxis({
            	labelRenderer: function(date) { return date.format("H:i:s"); }
           	 })		
        }]
	});
	
	var botonShowGraph = new Ext.Button({
		text : 'Show graph'
		,handler : function(){
			var item = gridGrid.getSelectionModel().getSelected();
			
			Ext.Ajax.request({
			 url : '/${appProperties.appName}/bam/monitorize.htm'
			 ,params : { label : item.data.Label }
			 ,scope : graphPanel
			 ,method : 'GET'
			 ,success : function(){
			     /*this.load({
				    url : '/${appProperties.appName}/bam/chart.htm'
				    ,params : { monitor : 'consoleChart'}
			     });*/
			     runner.stopAll();
			     graphStore.reload();
			     runner.start(task);
			 }
			});
			
		}		
			
	});

	var gridGrid = new Ext.grid.GridPanel({
		store : gridStore
		,title : 'Statistics'
		,cm : gridCm
		,width : 700
		,height : 400
		,tbar : [botonRefresh, botonEnableDisable, botonReset, botonShowGraph]
	});

	var panel	= new Ext.Panel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [gridGrid, graphPanel]
	});

	page.add(panel);

</fwk:page>

<div id="mago">
<table>
<tr><td style="text-align: center;"><img src="../fwk/img/wizard.gif" /><br/><font size="1">Powered by DEVON</font></td></tr>
</table>
</div> 
