<template>
    <BaseLayout title="GameDeployments" kind="GameDeployment" type="crd" category="custom_objects" default-crd="gamedeployments.tkex.tencent.com"
        default-active-detail-type="yaml" :show-detail-tab="false" :show-crd="false">
        <template #default="{ curPageData, pageConf, handlePageChange, handlePageSizeChange, handleGetExtData, handleUpdateResource,
                              handleDeleteResource,handleSortChange, handleShowDetail, renderCrdHeader, getJsonPathValue, additionalColumns, webAnnotations }">
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
                <bk-table-column :label="$t('命名空间')" prop="metadata.namespace" min-width="100" sortable>
                    <template #default="{ row }">
                        {{ row.metadata.namespace || '--' }}
                    </template>
                </bk-table-column>
                <bk-table-column :label="$t('升级策略')" width="150" :resizable="false">
                    <template slot-scope="{ row }">
                        <span v-if="row.spec.updateStrategy">
                            {{ row.spec.updateStrategy.type === 'RollingUpdate'
                                ? $t('滚动升级') : $t('原地升级') }}
                        </span>
                        <span v-else>{{ $t('滚动升级') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column
                    v-for="item in additionalColumns"
                    :key="item.name"
                    :label="item.name"
                    :prop="item.jsonPath"
                    :render-header="renderCrdHeader">
                    <template #default="{ row }">
                        <span>
                            {{ typeof getJsonPathValue(row, item.jsonPath) !== 'undefined'
                                ? getJsonPathValue(row, item.jsonPath) : '--' }}
                        </span>
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
                            v-authority="{
                                clickable: webAnnotations.perms.items[row.metadata.uid] ? webAnnotations.perms.items[row.metadata.uid].deleteBtn.clickable : true,
                                content: webAnnotations.perms.items[row.metadata.uid] ? webAnnotations.perms.items[row.metadata.uid].deleteBtn.tip : '',
                                disablePerms: true
                            }"
                            @click="handleDeleteResource(row)">{{ $t('删除') }}</bk-button>
                    </template>
                </bk-table-column>
            </bk-table>
        </template>
    </BaseLayout>
</template>
<script>
    import { defineComponent } from '@vue/composition-api'
    import BaseLayout from '@/views/dashboard/common/base-layout'

    export default defineComponent({
        name: 'GameDeployments',
        components: { BaseLayout }
    })
</script>
