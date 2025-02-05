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

  const handleInputChange = async (e) => {
    const value = e.target.value;
    setInput(value);
    
    // Test data for development
    if (value.length > 0) {
      // Simulate API response with test data
      setTimeout(() => {
        if (value === 'שלום') {
          setResults([
            ['של', 'לום'],
            ['שלום'],
            ['לש', 'ום']
          ]);
        } else if (value === 'אבג') {
          setResults([
            ['אב', 'ג'],
            ['א', 'בג']
          ]);
        } else {
          setResults([
            [value + ' (test)']
          ]);
        }
      }, 300); // Simulate network delay
    } else {
      setResults([]);
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
        </VStack>
      </VStack>
    </Container>
  );
}
