<template>
    <BaseLayout title="HPA" kind="HorizontalPodAutoscaler" type="hpa">
        <template #default="{ curPageData, pageConf, handlePageChange, handlePageSizeChange, handleGetExtData, handleSortChange, handleShowDetail, handleUpdateResource, handleDeleteResource }">
            <bk-table
                :data="curPageData"
                :pagination="pageConf"
                @page-change="handlePageChange"
                @page-limit-change="handlePageSizeChange"
                @sort-change="handleSortChange">
                <bk-table-column :label="$t('名称')" prop="metadata.name" sortable>
                    <template #default="{ row }">
                        <bk-button class="bcs-button-ellipsis" text @click="handleShowDetail(row)">{{ row.metadata.name }}</bk-button>
                    </template>
                </bk-table-column>
                <bk-table-column :label="$t('命名空间')" prop="metadata.namespace" sortable></bk-table-column>
                <bk-table-column label="Reference">
                    <template #default="{ row }">
                        <span>{{ handleGetExtData(row.metadata.uid, 'reference') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="Targets" :resizable="false">
                    <template #default="{ row }">
                        <span>{{ handleGetExtData(row.metadata.uid, 'targets') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="MinPods" :resizable="false">
                    <template #default="{ row }">
                        <span>{{ handleGetExtData(row.metadata.uid, 'minPods') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="MaxPods" :resizable="false">
                    <template #default="{ row }">
                        <span>{{ handleGetExtData(row.metadata.uid, 'maxPods') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="Replicas" :resizable="false">
                    <template #default="{ row }">
                        <span>{{ handleGetExtData(row.metadata.uid, 'replicas') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="Age" :resizable="false" :show-overflow-tooltip="false">
                    <template #default="{ row }">
                        <span v-bk-tooltips="{ content: handleGetExtData(row.metadata.uid, 'createTime') }">{{ handleGetExtData(row.metadata.uid, 'age') }}</span>
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
                <bk-table-column :label="$t('操作')" :resizable="false" width="150">
                    <template #default="{ row }">
                        <bk-button text
                            @click="handleUpdateResource(row)">{{ $t('更新') }}</bk-button>
                        <bk-button class="ml10" text
                            @click="handleDeleteResource(row)">{{ $t('删除') }}</bk-button>
                    </template>
                </bk-table-column>
            </bk-table>
        </template>
        <template #detail="{ data, extData }">
            <HPADetail :data="data" :ext-data="extData"></HPADetail>
        </template>
    </BaseLayout>
</template>
<script>
    import { defineComponent } from '@vue/composition-api'
    import HPADetail from './hpa-detail.vue'
    import BaseLayout from '@/views/dashboard/common/base-layout'

    export default defineComponent({
        components: { BaseLayout, HPADetail }
    })
</script>
