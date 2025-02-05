import { ChakraProvider, ColorModeScript } from '@chakra-ui/react';
import { AnagramSolver } from './components/AnagramSolver';
import theme from './theme';

function App() {
  return (
    <>
      <ColorModeScript initialColorMode={theme.config.initialColorMode} />
      <ChakraProvider theme={theme}>
        <AnagramSolver />
      </ChakraProvider>
    </>
  );
}

export default App;
