
package com.govmade.common.utils.echarts;
import com.govmade.common.utils.echarts.json.GsonUtil;

/**
 * 增强的Option
 */
public class GsonOption extends Option {

    @Override
    /**
     * 获取toString值
     */
    public String toString() {
        return GsonUtil.format(this);
    }



}
