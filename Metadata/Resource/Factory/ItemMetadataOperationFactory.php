<?php

/*
 * This file is part of the DunglasApiBundle package.
 *
 * (c) Kévin Dunglas <dunglas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Dunglas\ApiBundle\Metadata\Resource\Factory;

use Dunglas\ApiBundle\Metadata\Resource\ItemMetadata;

/**
 * Creates or completes operations.
 *
 * @author Kévin Dunglas <dunglas@gmail.com>
 */
class ItemMetadataOperationFactory implements ItemMetadataFactoryInterface
{
    /**
     * @var ItemMetadataFactoryInterface
     */
    private $decorated;

    public function __construct(ItemMetadataFactoryInterface $decorated)
    {
        var_dump($decorated);
        die;
        $this->decorated = $decorated;
    }

    /**
     * {@inheritdoc}
     */
    public function create(string $resourceClass) : ItemMetadata
    {
        $itemMetadata = $this->decorated->create($resourceClass);
        $reflectionClass = new \ReflectionClass($resourceClass);
        $isAbstract = $reflectionClass->isAbstract();

        if (null === $itemMetadata->getCollectionOperations()) {
            $itemMetadata = $itemMetadata->withCollectionOperations($this->createOperations(
                $isAbstract ? ['GET'] : ['GET', 'POST']
            ));
        }

        if (null === $itemMetadata->getItemOperations()) {
            $itemMetadata = $itemMetadata->withItemOperations($this->createOperations(
                $isAbstract ? ['GET', 'DELETE'] : ['GET', 'PUT', 'DELETE']
            ));
        }

        return $itemMetadata;
    }

    private function createOperations(array $methods) : array
    {
        $operations = [];
        foreach ($methods as $method) {
            $operations[strtolower($method)] = ['method' => $method];
        }

        return $operations;
    }
}
