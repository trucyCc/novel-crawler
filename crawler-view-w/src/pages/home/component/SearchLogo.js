import React from 'react';
import { styled } from '@mui/system';

const LogoContainer = styled('div')({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  height: '100%',
});

const LogoImage = styled('img')({
  width: 600,
  height: 600,
});

const SearchLogo = () => {
  return (
    <LogoContainer>
      <LogoImage src="http://inews.gtimg.com/newsapp_bt/0/13864904767/1000" alt="your-logo" />
    </LogoContainer>
  );
};

export default SearchLogo;
