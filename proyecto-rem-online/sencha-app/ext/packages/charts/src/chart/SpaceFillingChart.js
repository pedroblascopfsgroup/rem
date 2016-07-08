/**
 * @class Ext.chart.SpaceFillingChart
 * @extends Ext.chart.AbstractChart
 *
 * Creates a chart that fills the entire area of the chart.
 * e.g. Gauge Charts
 */
Ext.define('Ext.chart.SpaceFillingChart', {

    extend: 'Ext.chart.AbstractChart',
    xtype: 'spacefilling',

    config: {

    },

    performLayout: function () {
        var me = this;

        try {
            me.animationSuspendCount++;
            if (me.callParent() === false) {
                // animationSuspendCount will still be decremented
                return;
            }

            var chartRect = me.getSurface('chart').getRect(),
                padding = me.getInsetPadding(),
                width = chartRect[2] - padding.left - padding.right,
                height = chartRect[3] - padding.top - padding.bottom,
                mainRect = [padding.left, padding.top, width, height],
                seriesList = me.getSeries(), series,
                i, ln;

            me.getSurface().setRect(mainRect);
            me.setMainRect(mainRect);

            for (i = 0, ln = seriesList.length; i < ln; i++) {
                series = seriesList[i];
                series.getSurface().setRect(mainRect);
                if (series.setRect) {
                    series.setRect(mainRect);
                }
                series.getOverlaySurface().setRect(chartRect);
            }
            me.redraw();
        } catch (e) { // catch is required in IE8 (try/finally not supported)
            //<debug>
            Ext.log.error(me.$className + ': Unhandled Exception: ', e.description || e.message);
            //</debug>
            throw e;
        }
        finally {
            me.animationSuspendCount--;
        }
    },

    redraw: function () {
        var me = this,
            seriesList = me.getSeries(), series,
            i, ln;

        for (i = 0, ln = seriesList.length; i < ln; i++) {
            series = seriesList[i];
            series.getSprites();
        }

        me.renderFrame();
        me.callParent(arguments);
    }
});
