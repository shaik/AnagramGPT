import React, { useState } from 'react';
import {
  Box,
  Container,
  VStack,
  Input,
  Text,
  Heading,
  useColorModeValue,
  IconButton,
  Flex,
  Badge,
  Card,
  CardBody,
  SimpleGrid,
} from '@chakra-ui/react';
import { motion } from 'framer-motion';
import { MoonIcon, SunIcon } from '@chakra-ui/icons';

export function AnagramSolver() {
  const [input, setInput] = useState('');
  const [results, setResults] = useState([]);

  const [debug, setDebug] = useState(null);

  const handleInputChange = async (e) => {
    const value = e.target.value;
    setInput(value);
    
    if (value.length > 0) {
      try {
        const response = await fetch('http://localhost:3000/api/anagram', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ text: value }),
        });
        
        if (response.ok) {
          const data = await response.json();
          setResults(data.results);
          setDebug(data.debug);
        } else {
          console.error('Error fetching anagrams:', response.statusText);
          setResults([]);
          setDebug(null);
        }
      } catch (error) {
        console.error('Error fetching anagrams:', error);
        setResults([]);
        setDebug(null);
      }
    } else {
      setResults([]);
      setDebug(null);
    }
  };

  const colorMode = useColorModeValue('light', 'dark');
  const toggleColorMode = () => {
    // This will be implemented when we add color mode support
  };

  return (
    <Container maxW="container.lg" py={8}>
      <VStack spacing={8}>
        <Flex w="full" justify="space-between" align="center">
          <Heading size="lg">פותר האנגרמות</Heading>
          <IconButton
            icon={colorMode === 'light' ? <MoonIcon /> : <SunIcon />}
            variant="ghost"
            aria-label="Toggle dark mode"
            onClick={toggleColorMode}
          />
        </Flex>

        <VStack spacing={6} w="full">
          <Input
            size="lg"
            placeholder="הכנס טקסט כאן..."
            textAlign="right"
            dir="rtl"
            fontSize="xl"
            borderRadius="full"
            borderWidth={2}
            _focus={{
              borderColor: 'teal.500',
              boxShadow: '0 0 0 1px teal.500',
            }}
            value={input}
            onChange={handleInputChange}
          />
          <SimpleGrid columns={{ base: 1, md: 2 }} spacing={4} w="full">
            {results.map((result, idx) => (
              <Card
                key={idx}
                as={motion.div}
                whileHover={{ y: -5 }}
                transition="0.2s"
              >
                <CardBody>
                  <Text fontSize="xl" dir="rtl">
                    {result.join(' ')}
                  </Text>
                  <Badge colorScheme="teal" mt={2}>
                    {result.length} מילים
                  </Badge>
                </CardBody>
              </Card>
            ))}
          </SimpleGrid>
          {debug && (
            <Box mt={4} p={4} bg="gray.100" borderRadius="md">
              <Text fontSize="sm" fontFamily="monospace" whiteSpace="pre-wrap">
                Raw Text:
                - Original: {debug.raw.original}
                - Is UTF-8: {debug.raw.is_utf8 ? 'Yes' : 'No'}
                - Length: {debug.raw.length}
                - Bytes: {debug.raw.bytes}
                
                Decoded Text:
                - Original: {debug.decoded.original}
                - Is UTF-8: {debug.decoded.is_utf8 ? 'Yes' : 'No'}
                - Length: {debug.decoded.length}
                - Bytes: {debug.decoded.bytes}
                
                {debug.error && (
                  <Box color="red.500" mt={2}>
                    Error: {debug.error}
                  </Box>
                )}
              </Text>
            </Box>
          )}
        </VStack>
      </VStack>
    </Container>
  );
}
