"use client"
import { useRouter } from 'next/navigation';

const NovalPage = () => {
  const router = useRouter();

  // 获取路由参数值
  const { novalId } = router.query;
  return (
    <div>
      NovalPage
      <h1>Noval ID: {novalId}</h1>
    </div>
  );
};

export default NovalPage;
