<template>
    <div class="biz-content">
        <BaseLayout title="Pods" kind="Pod" category="pods" type="workloads">
            <template #default="{ curPageData, pageConf, handlePageChange, handlePageSizeChange, handleGetExtData, gotoDetail, handleSortChange,handleUpdateResource,handleDeleteResource }">
                <bk-table
                    :data="curPageData"
                    :pagination="pageConf"
                    @page-change="handlePageChange"
                    @page-limit-change="handlePageSizeChange"
                    @sort-change="handleSortChange">
                    <bk-table-column :label="$t('名称')" min-width="130" prop="metadata.name" sortable>
                        <template #default="{ row }">
                            <bk-button class="bcs-button-ellipsis" text @click="gotoDetail(row)">{{ row.metadata.name }}</bk-button>
                        </template>
                    </bk-table-column>
                    <bk-table-column :label="$t('命名空间')" width="150" prop="metadata.namespace" sortable></bk-table-column>
                    <bk-table-column :label="$t('镜像')" min-width="200" :show-overflow-tooltip="false">
                        <template slot-scope="{ row }">
                            <span v-bk-tooltips.top="(handleGetExtData(row.metadata.uid, 'images') || []).join('<br />')">
                                {{ (handleGetExtData(row.metadata.uid, 'images') || []).join(', ') }}
                            </span>
                        </template>
                    </bk-table-column>
                    <bk-table-column label="Status" width="120" :resizable="false">
                        <template slot-scope="{ row }">
                            <StatusIcon :status="handleGetExtData(row.metadata.uid, 'status')"></StatusIcon>
                        </template>
                    </bk-table-column>
                    <bk-table-column label="Ready" width="100" :resizable="false">
                        <template slot-scope="{ row }">
                            {{handleGetExtData(row.metadata.uid, 'readyCnt')}}/{{handleGetExtData(row.metadata.uid, 'totalCnt')}}
                        </template>
                    </bk-table-column>
                    <bk-table-column label="Restarts" width="100" :resizable="false">
                        <template slot-scope="{ row }">{{handleGetExtData(row.metadata.uid, 'restartCnt')}}</template>
                    </bk-table-column>
                    <bk-table-column label="Host IP" width="140" :resizable="false">
                        <template slot-scope="{ row }">{{row.status.hostIP || '--'}}</template>
                    </bk-table-column>
                    <bk-table-column label="Pod IP" width="140" :resizable="false">
                        <template slot-scope="{ row }">{{row.status.podIP || '--'}}</template>
                    </bk-table-column>
                    <bk-table-column label="Node" :resizable="false">
                        <template slot-scope="{ row }">{{row.spec.nodeName || '--'}}</template>
                    </bk-table-column>
                    <bk-table-column label="Age" :resizable="false">
                        <template #default="{ row }">
                            <span>{{handleGetExtData(row.metadata.uid, 'age')}}</span>
                        </template>
                    </bk-table-column>
                    <bk-table-column :label="$t('编辑模式')" width="100">
                        <template slot-scope="{ row }">
                            <span>
                                {{handleGetExtData(row.metadata.uid, 'editMode') === 'form'
                                    ? $t('表单') : 'YAML'}}
                            </span>
                        </template>
                    </bk-table-column>
                    <bk-table-column :label="$t('操作')" :resizable="false" width="180">
                        <template #default="{ row }">
                            <bk-button text @click="handleShowLog(row, clusterId)">{{ $t('日志') }}</bk-button>
                            <bk-button text class="ml10"
                                @click="handleUpdateResource(row)">{{ $t('更新') }}</bk-button>
                            <bk-button class="ml10" text
                                @click="handleDeleteResource(row)">{{ $t('删除') }}</bk-button>
                        </template>
                    </bk-table-column>
                </bk-table>
            </template>
        </BaseLayout>
        <bcs-dialog class="log-dialog" v-model="logShow" width="80%" :show-footer="false" render-directive="if">
            <BcsLog
                :project-id="projectId"
                :cluster-id="clusterId"
                :namespace-id="curNamespace"
                :pod-id="curPodId"
                :default-container="defaultContainer"
                :global-loading="logLoading"
                :container-list="containerList">
            </BcsLog>
        </bcs-dialog>
    </div>
</template>
<script>
    import { defineComponent, computed } from '@vue/composition-api'
    import BaseLayout from '@/views/dashboard/common/base-layout'
    import StatusIcon from '@/views/dashboard/common/status-icon'
    import BcsLog from '@/components/bcs-log/index'
    import useLog from './detail/use-log'

    export default defineComponent({
        components: { BaseLayout, StatusIcon, BcsLog },
        setup (props, ctx) {
            const { $route, $store } = ctx.root
            const projectId = computed(() => $route.params.projectId)
            const clusterId = computed(() => $store.state.curClusterId)
            return {
                projectId,
                clusterId,
                ...useLog()
            }
        }
    })
</script>
<style lang="postcss" scoped>
@import './detail/pod-log.css';
/deep/ .base-layout {
    width: 100%;
}
</style>
