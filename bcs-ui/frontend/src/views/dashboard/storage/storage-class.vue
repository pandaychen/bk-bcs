<template>
    <BaseLayout title="StorageClasses" kind="StorageClass" category="storage_classes" type="storages" :show-name-space="false" :show-create="false">
        <template #default="{ curPageData, pageConf, handlePageChange, handlePageSizeChange, handleGetExtData, handleSortChange }">
            <bk-table
                :data="curPageData"
                :pagination="pageConf"
                @page-change="handlePageChange"
                @page-limit-change="handlePageSizeChange"
                @sort-change="handleSortChange">
                <bk-table-column :label="$t('名称')" prop="metadata.name" sortable></bk-table-column>
                <bk-table-column label="Provisioner">
                    <template #default="{ row }">
                        <span>{{ row.provisioner || '--' }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="Reclaim Policy">
                    <template #default="{ row }">
                        <span>{{ row.reclaimPolicy || 'Delete' }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="VolumeBindingMode">
                    <template #default="{ row }">
                        <span>{{ row.volumeBindingMode || 'Immediate' }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="Parameters">
                    <template #default="{ row }">
                        <span>{{ handleParseObjToArr(row, 'parameters') || '--' }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="MountOptions">
                    <template #default="{ row }">
                        <span>{{ (row.mountOptions || []).join(', ') || '--' }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="AllowVolumeExpansion">
                    <template #default="{ row }">
                        <span>{{ row.allowVolumeExpansion || 'false' }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="IsDefaultClass">
                    <template #default="{ row }">
                        <span>{{ handleGetExtData(row.metadata.uid, 'isDefault') }}</span>
                    </template>
                </bk-table-column>
                <bk-table-column label="Age" :resizable="false" :show-overflow-tooltip="false">
                    <template #default="{ row }">
                        <span v-bk-tooltips="{ content: handleGetExtData(row.metadata.uid, 'createTime') }">{{ handleGetExtData(row.metadata.uid, 'age') }}</span>
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
        components: { BaseLayout },
        setup () {
            const handleParseObjToArr = (row, prop) => {
                return Object.keys(row[prop] || {}).map(key => {
                    return `${key}=${row[prop][key]}`
                }).join(', ')
            }
            return {
                handleParseObjToArr
            }
        }
    })
</script>
