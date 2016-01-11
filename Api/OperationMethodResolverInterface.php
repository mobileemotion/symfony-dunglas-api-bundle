<?php

/*
 * This file is part of the DunglasApiBundle package.
 *
 * (c) Kévin Dunglas <dunglas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Dunglas\ApiBundle\Api;

use Dunglas\ApiBundle\Exception\RuntimeException;

/**
 * Resolves the HTTP method associated with an operation.
 *
 * @author Kévin Dunglas <dunglas@gmail.com>
 */
interface OperationMethodResolverInterface
{
    /**
     * @param string $resourceClass
     * @param string $operationName
     *
     * @throws RuntimeException
     *
     * @return string
     */
    public function getCollectionOperationMethod(string $resourceClass, string $operationName) : string;

    /**
     * @param string $resourceClass
     * @param string $operationName
     *
     * @throws RuntimeException
     *
     * @return string
     */
    public function getItemOperationMethod(string $resourceClass, string $operationName) : string;
}