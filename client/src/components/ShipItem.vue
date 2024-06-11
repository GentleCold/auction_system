<template>
  <el-dialog title="Ship Item" :visible.sync="visible">
    <p>Are you sure you want to ship this item?</p>
    <el-button type="primary" @click="shipItem">Confirm</el-button>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['close', 'itemShipped']);
const visible = ref(true);

const shipItem = async () => {
  const accounts = await web3.eth.getAccounts();
  
  await auctionContract.methods.shipItem(props.item.id).send({ from: accounts[0] });
  
  emit('itemShipped');
  emit('close');
};
</script>
