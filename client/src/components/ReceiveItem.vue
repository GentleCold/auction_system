<template>
  <el-dialog title="买家收货" :visible.sync="visible">
    <p>请确认您已收到货物</p>
    <el-button type="primary" @click="receiveItem">确认</el-button>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue';
import { web3, auctionContract } from '../utils/web3';

const props = defineProps({
  item: Object
});

const emit = defineEmits(['close', 'itemReceived']);
const visible = ref(true);

const receiveItem = async () => {
  const accounts = await web3.eth.getAccounts();
  
  await auctionContract.methods.receiveItem(props.item.id).send({ from: accounts[0] });
  
  emit('itemReceived');
  emit('close');
};
</script>
