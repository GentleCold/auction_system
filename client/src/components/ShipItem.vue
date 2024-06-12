<template>
  <el-dialog title="卖家发货" :visible.sync="visible">
    <p>请确认您已发货</p>
    <el-button type="primary" @click="shipItem">确认</el-button>
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
